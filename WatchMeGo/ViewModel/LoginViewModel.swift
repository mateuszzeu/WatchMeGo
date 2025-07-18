//
//  LoginViewModel.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//

import Foundation
import FirebaseAuth

@Observable
final class LoginViewModel {
    var infoMessage: String?

    func login(email: String, password: String, coordinator: Coordinator) async {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            let user = result.user

            let newUser = AppUser(
                id: user.uid,
                email: user.email ?? email,
                name: user.email?.components(separatedBy: "@").first ?? email
            )

            await MainActor.run {
                coordinator.login(newUser)
                self.infoMessage = "Signed in!"
            }
        } catch {
            await MainActor.run {
                self.infoMessage = error.localizedDescription
            }
        }
    }
}

