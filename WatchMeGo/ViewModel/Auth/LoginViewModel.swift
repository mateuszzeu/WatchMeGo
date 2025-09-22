//
//  LoginViewModel.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//

import Foundation
import FirebaseAuth
import LocalAuthentication

@MainActor
@Observable
final class LoginViewModel {
    var faceIDError: String?
    var lastLoggedInUser: AppUser?
    var isQuickLoginAvailable = false
    
    init() {
        checkQuickLoginAvailability()
    }
    
    private func checkQuickLoginAvailability() {
        if let currentUser = Auth.auth().currentUser {
            Task {
                do {
                    let appUser = try await UserService.fetchUser(byID: currentUser.uid)
                    lastLoggedInUser = appUser
                    isQuickLoginAvailable = true
                } catch {
                    isQuickLoginAvailable = false
                }
            }
        } else {
            isQuickLoginAvailable = false
        }
    }
    
    func login(email: String, password: String, coordinator: Coordinator) async {
        do {
            MessageHandler.shared.clearMessage()
            
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            let user = result.user
            
            let appUser = try await UserService.fetchUser(byID: user.uid)
            coordinator.login(appUser)
            
            lastLoggedInUser = appUser
            
            MessageHandler.shared.showSuccess("Signed in!")
            
            isQuickLoginAvailable = true
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    func authenticateWithFaceID() async -> Bool {
        let context = LAContext()
        let reason = "Log in to WatchMeGo"
        
        do {
            let success = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
            return success
        } catch {
            faceIDError = "Authentication failed"
            return false
        }
    }
    
    func quickLoginWithFaceID(coordinator: Coordinator) async {
        guard let user = lastLoggedInUser else {
            faceIDError = "No saved user found"
            return
        }

        faceIDError = nil
        MessageHandler.shared.clearMessage()

        guard await authenticateWithFaceID() else { return }

        guard Auth.auth().currentUser?.uid == user.id else {
            lastLoggedInUser = nil
            isQuickLoginAvailable = false
            faceIDError = "User session expired"
            return
        }

        do {
            _ = try await UserService.fetchUser(byID: user.id)
            coordinator.login(user)
        } catch {
            lastLoggedInUser = nil
            isQuickLoginAvailable = false
            faceIDError = "User account no longer exists"
        }
    }
}
