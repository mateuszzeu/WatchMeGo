//
//  ManageViewModel.swift
//  WatchMeGo
//
//  Created by Liza on 21/07/2025.
//

import Foundation

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
                pendingUsers.removeAll { $0.id == user.id }
                if !coordinator.currentUser!.friends.contains(user.name) {
                    coordinator.currentUser!.friends.append(user.name)
                }
                friends.append(user)
            } catch {
                ErrorHandler.shared.handle(error)
            }
        }
    }
    
    func decline(_ user: AppUser, coordinator: Coordinator) {
        Task {
            do {
                try await UserService.declineInvite(my: coordinator.currentUser!, from: user)
                pendingUsers.removeAll { $0.id == user.id }
            } catch {
                ErrorHandler.shared.handle(error)
            }
        }
    }
}
