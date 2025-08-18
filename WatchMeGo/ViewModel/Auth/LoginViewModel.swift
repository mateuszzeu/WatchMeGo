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

            let appUser = try await UserService.fetchUser(byID: user.uid)
            coordinator.login(appUser)
            infoMessage = "Signed in!"
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
}
