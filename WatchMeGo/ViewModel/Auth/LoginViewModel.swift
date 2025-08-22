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
    var infoMessage: String?
    var lastLoggedInUser: AppUser?
    var faceIDError: String?

    init() {
        loadLastLoggedInUser()
    }

    func login(email: String, password: String, coordinator: Coordinator) async {
        do {
            MessageHandler.shared.clearMessage()
            
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            let user = result.user

            let appUser = try await UserService.fetchUser(byID: user.uid)
            coordinator.login(appUser)
            infoMessage = "Signed in!"

            if let userData = try? JSONEncoder().encode(appUser) {
                UserDefaults.standard.set(userData, forKey: "lastLoggedInUser")
            }
        } catch {
            MessageHandler.shared.showError(error)
        }
    }

    func loadLastLoggedInUser() {
        if let userData = UserDefaults.standard.data(forKey: "lastLoggedInUser"),
           let user = try? JSONDecoder().decode(AppUser.self, from: userData) {
            lastLoggedInUser = user
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
        
        let success = await authenticateWithFaceID()
        if success {
            MessageHandler.shared.clearMessage()
            infoMessage = nil
            
            coordinator.login(user)
            UserDefaults.standard.set(Date(), forKey: "lastLoginTime")
        }
    }
}
