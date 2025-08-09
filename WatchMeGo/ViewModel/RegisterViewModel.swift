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
            guard try await isUsernameAvailable(username) else {
                throw AppError.usernameTaken
            }
            
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
                activeCompetitionWith: nil,
                pendingCompetitionWith: nil
            )

            try await UserService.createUser(appUser)
            coordinator.login(appUser)
            infoMessage = "Registered & Signed in!"
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }

    private func isUsernameAvailable(_ name: String) async throws -> Bool {
        let snap = try await Firestore.firestore()
            .collection("users")
            .whereField("name", isEqualTo: name)
            .limit(to: 1)
            .getDocuments()
        return snap.documents.isEmpty
    }
}
