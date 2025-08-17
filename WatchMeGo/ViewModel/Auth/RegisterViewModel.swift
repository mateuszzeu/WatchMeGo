//
//  RegisterViewModel.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
@Observable
final class RegisterViewModel {
    var infoMessage: String?

    func register(email: String, password: String, username: String, coordinator: Coordinator) async {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let firebaseUser = result.user
            
            let appUser = AppUser(
                id: firebaseUser.uid,
                name: username,
                email: email,
                createdAt: Date(),
                friends: [],
                pendingInvites: [],
                sentInvites: [],
                currentProgress: nil,
                history: [:],
                activeCompetitionWith: nil,
                pendingCompetitionWith: nil
            )
            
            try await UserService.createUser(appUser)
            coordinator.login(appUser)
            infoMessage = "Registered & Signed in!"
        } catch let error as NSError {
            if error.code == 17007 {
                ErrorHandler.shared.handle(AppError.usernameTaken)
            } else {
                ErrorHandler.shared.handle(error)
            }
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }
    
    private func isUsernameAvailable(_ username: String) async throws -> Bool {
        // TO DO - implement proper username validation
        return true
    }
}
