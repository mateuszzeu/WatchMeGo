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
            try validateInput(email: email, password: password, username: username)
            
            let formattedUsername = formatUsername(username)
            
            guard try await isUsernameAvailable(formattedUsername) else {
                throw AppError.usernameTaken
            }

            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let firebaseUser = result.user

            let appUser = AppUser(
                id: firebaseUser.uid,
                name: formattedUsername,
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
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    func validateInput(email: String, password: String, username: String) throws {
        if email.isEmpty {
            throw AppError.emptyField(fieldName: "Email")
        }
        
        if !isValidEmail(email) {
            throw AppError.invalidEmail
        }
        
        if password.isEmpty {
            throw AppError.emptyField(fieldName: "Password")
        }
        
        if password.count < 6 {
            throw AppError.passwordTooShort
        }
        
        if username.isEmpty {
            throw AppError.emptyField(fieldName: "Username")
        }
        
        if username.count < 3 {
            throw AppError.usernameTooShort
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func formatUsername(_ username: String) -> String {
        let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return username }
        
        let firstLetter = trimmed.prefix(1).uppercased()
        let rest = trimmed.dropFirst().lowercased()
        return firstLetter + rest
    }

    func isUsernameAvailable(_ username: String) async throws -> Bool {
        let snapshot = try await Firestore.firestore()
            .collection("users")
            .whereField("name", isEqualTo: username)
            .limit(to: 1)
            .getDocuments()
        return snapshot.documents.isEmpty
    }
}
