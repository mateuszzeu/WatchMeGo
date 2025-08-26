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
    private(set) var currentUser: AppUser

    var usernameToInvite = ""

    var pendingUsers: [AppUser] = []
    var friends: [AppUser] = []

    init(currentUser: AppUser) {
        self.currentUser = currentUser
    }

    func sendInviteTapped() {
        Task {
            do {
                try await UserService.sendInvite(from: currentUser, toUsername: usernameToInvite)
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
            currentUser = try await UserService.fetchUser(byID: currentUser.id)

            let pendingNames = currentUser.pendingInvites
            let friendNames = currentUser.friends

            pendingUsers = try await UserService.fetchUsers(byUsernames: pendingNames)
            friends = try await UserService.fetchUsers(byUsernames: friendNames)
        } catch {
            MessageHandler.shared.showError(error)
        }
    }

    func accept(_ user: AppUser) {
        Task {
            do {
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
                try await UserService.declineInvite(my: currentUser, from: user)
                MessageHandler.shared.showSuccess("Invitation declined")
                try await reloadUserAndData()
            } catch {
                MessageHandler.shared.showError(error)
            }
        }
    }

    func isInCompetition(with friend: AppUser) -> Bool {
        currentUser.activeCompetitionWith == friend.id
    }

    private func reloadUserAndData() async throws {
        currentUser = try await UserService.fetchUser(byID: currentUser.id)
        await loadData()
    }
}
