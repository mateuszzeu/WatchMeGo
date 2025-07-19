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

            UserService.fetchUser(id: user.uid) { result in
                switch result {
                case .success(let appUser):
                    Task { @MainActor in
                        coordinator.login(appUser)
                        self.infoMessage = "Signed in!"
                    }
                case .failure(let error):
                    Task { @MainActor in
                        self.infoMessage = "User data not found: \(error.localizedDescription)"
                    }
                }
            }

        } catch {
            await MainActor.run {
                self.infoMessage = error.localizedDescription
            }
        }
    }
}


