//
//  LoginViewModel.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//

import Foundation
import FirebaseAuth

@MainActor
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
                    coordinator.login(appUser)
                    self.infoMessage = "Signed in!"
                case .failure(let error):
                    ErrorHandler.shared.handle(error)
                }
            }
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }
}



