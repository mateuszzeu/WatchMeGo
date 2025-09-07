//
//  ManageViewModel.swift
//  WatchMeGo
//
//  Created by Liza on 21/07/2025.
//

import Foundation

@MainActor
@Observable
final class ManageViewModel {
    private let coordinator: Coordinator

    var usernameToInvite = ""

    var pendingUsers: [AppUser] = []
    var friends: [AppUser] = []
    
    var currentUser: AppUser? {
        coordinator.currentUser
    }

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    func sendInviteTapped() {
        Task {
            do {
                guard let user = currentUser else { return }
                try await UserService.sendInvite(from: user, toUsername: usernameToInvite)
                MessageHandler.shared.showSuccess("Invitation sent to \(usernameToInvite)!")
                usernameToInvite = ""
                try await reloadUserAndData()
            } catch {
                MessageHandler.shared.showError(error)
            }
        }
    }

    func loadData() async {
        do {
            try await coordinator.refreshCurrentUser()

            let pendingNames = coordinator.currentUser?.pendingInvites ?? []
            let friendNames = coordinator.currentUser?.friends ?? []

            pendingUsers = try await UserService.fetchUsers(byUsernames: pendingNames)
            friends = try await UserService.fetchUsers(byUsernames: friendNames)
        } catch {
            MessageHandler.shared.showError(error)
        }
    }

    func accept(_ user: AppUser) {
        Task {
            do {
                guard let currentUser = currentUser else { return }
                try await UserService.acceptInvite(my: currentUser, from: user)
                MessageHandler.shared.showSuccess("You are now friends with \(user.name)!")
                try await reloadUserAndData()
            } catch {
                MessageHandler.shared.showError(error)
            }
        }
    }

    func decline(_ user: AppUser) {
        Task {
            do {
                guard let currentUser = currentUser else { return }
                try await UserService.declineInvite(my: currentUser, from: user)
                MessageHandler.shared.showSuccess("Invitation declined")
                try await reloadUserAndData()
            } catch {
                MessageHandler.shared.showError(error)
            }
        }
    }

    func isInCompetition(with friend: AppUser) -> Bool {
        currentUser?.activeCompetitionWith == friend.id
    }

    private func reloadUserAndData() async throws {
        try await coordinator.refreshCurrentUser()
        await loadData()
    }
}
