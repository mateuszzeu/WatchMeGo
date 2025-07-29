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
    var usernameToInvite = ""
    var inviteStatus: String?
    var pendingUsers: [AppUser] = []
    var friends: [AppUser] = []

    func sendInviteTapped(coordinator: Coordinator) {
        Task {
            do {
                try await UserService.sendInvite(from: coordinator.currentUser!, toUsername: usernameToInvite)
                inviteStatus = "Invite sent!"
                usernameToInvite = ""
                await refreshUserAndReload(coordinator: coordinator)
            } catch {
                ErrorHandler.shared.handle(error)
                inviteStatus = nil
            }
        }
    }

    func loadData(coordinator: Coordinator) async {
        let pendingNames = coordinator.currentUser?.pendingInvites ?? []
        let friendNames = coordinator.currentUser?.friends ?? []
        do {
            pendingUsers = try await UserService.fetchUsers(usernames: pendingNames)
            friends = try await UserService.fetchUsers(usernames: friendNames)
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }

    func accept(_ user: AppUser, coordinator: Coordinator) {
        Task {
            do {
                try await UserService.acceptInvite(my: coordinator.currentUser!, from: user)
                await refreshUserAndReload(coordinator: coordinator)
            } catch {
                ErrorHandler.shared.handle(error)
            }
        }
    }

    func decline(_ user: AppUser, coordinator: Coordinator) {
        Task {
            do {
                try await UserService.declineInvite(my: coordinator.currentUser!, from: user)
                await refreshUserAndReload(coordinator: coordinator)
            } catch {
                ErrorHandler.shared.handle(error)
            }
        }
    }

    private func refreshUserAndReload(coordinator: Coordinator) async {
        await withCheckedContinuation { continuation in
            UserService.fetchUser(id: coordinator.currentUser!.id) { result in
                switch result {
                case .success(let updatedUser):
                    coordinator.currentUser = updatedUser
                    Task { await self.loadData(coordinator: coordinator) }
                case .failure(let error):
                    ErrorHandler.shared.handle(error)
                }
                continuation.resume()
            }
        }
    }
}

