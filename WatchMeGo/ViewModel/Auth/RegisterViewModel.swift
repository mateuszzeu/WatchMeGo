//
//  RegisterViewModel.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//

import Foundation
import FirebaseAuth

@MainActor
@Observable
final class RegisterViewModel {
    var infoMessage: String?

    func register(email: String, password: String, name: String, coordinator: Coordinator) async {
        do {
            try validateInput(email: email, password: password, name: name)
            
            let formattedName = formatName(name)
            
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let firebaseUser = result.user

            let appUser = AppUser(
                id: firebaseUser.uid,
                name: formattedName,
                email: email,
                createdAt: Date()
            )

            try await UserService.createUser(appUser)
            coordinator.login(appUser)
            infoMessage = "Registered & Signed in!"
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    func validateInput(email: String, password: String, name: String) throws {
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
        
        if name.isEmpty {
            throw AppError.emptyField(fieldName: "Name")
        }
        
        if name.count < 2 {
            throw AppError.nameTooShort
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func formatName(_ name: String) -> String {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return name }
        
        let firstLetter = trimmed.prefix(1).uppercased()
        let rest = trimmed.dropFirst().lowercased()
        return firstLetter + rest
    }
}
