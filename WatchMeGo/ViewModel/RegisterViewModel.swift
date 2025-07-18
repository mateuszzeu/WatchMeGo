//
//  RegisterViewModel.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//

import Foundation
import FirebaseAuth

@Observable
final class RegisterViewModel {
    var infoMessage: String?

    func register(email: String, password: String, coordinator: Coordinator) async {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = result.user

            let newUser = AppUser(
                id: user.uid,
                email: user.email ?? email,
                name: user.email?.components(separatedBy: "@").first ?? email
            )

            await MainActor.run {
                coordinator.login(newUser)
                self.infoMessage = "Registered & Signed in!"
            }
        } catch {
            await MainActor.run {
                self.infoMessage = error.localizedDescription
            }
        }
    }
}



