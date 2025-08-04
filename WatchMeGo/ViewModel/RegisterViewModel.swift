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

    func register(email: String, password: String, username: String, coordinator: Coordinator) async {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = result.user

            let appUser = AppUser(
                id: user.uid,
                name: username,
                createdAt: Date(),
                friends: [],
                pendingInvites: [],
                sentInvites: [],
                currentProgress: nil,
                history: [:],
                activeCompetitionWith: nil
            )
            try await UserService.createUser(appUser)
            coordinator.login(appUser)
            self.infoMessage = "Registered & Signed in!"
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }
}





