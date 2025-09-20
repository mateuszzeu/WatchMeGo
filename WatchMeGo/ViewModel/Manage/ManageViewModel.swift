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

    var emailToInvite = ""
    var pendingInvites: [Friendship] = []
    var requesterNames: [String: String] = [:]
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
                try await UserService.sendInvite(from: user.id, to: emailToInvite)
                MessageHandler.shared.showSuccess("Invitation sent to \(emailToInvite)!")
                emailToInvite = ""
                await loadData()
            } catch {
                MessageHandler.shared.showError(error)
            }
        }
    }

    func loadData() async {
        do {
            guard let user = currentUser else { return }
            
            pendingInvites = try await UserService.fetchPendingInvites(for: user.id)
            friends = try await UserService.fetchFriends(for: user.id)
            
            await loadRequesterNames()
        } catch {
            MessageHandler.shared.showError(error)
        }
    }

    func accept(_ friendship: Friendship) {
        Task {
            do {
                try await UserService.acceptInvite(friendshipId: friendship.id)
                MessageHandler.shared.showSuccess("Invitation accepted!")
                await loadData()
            } catch {
                MessageHandler.shared.showError(error)
            }
        }
    }

    func decline(_ friendship: Friendship) {
        Task {
            do {
                try await UserService.declineInvite(friendshipId: friendship.id)
                MessageHandler.shared.showSuccess("Invitation declined")
                await loadData()
            } catch {
                MessageHandler.shared.showError(error)
            }
        }
    }
    
    private func loadRequesterNames() async {
        requesterNames.removeAll()
        
        for friendship in pendingInvites {
            do {
                let name = try await UserService.fetchUserName(byID: friendship.requesterId)
                requesterNames[friendship.requesterId] = name
            } catch {
                requesterNames[friendship.requesterId] = friendship.requesterId
            }
        }
    }
}
