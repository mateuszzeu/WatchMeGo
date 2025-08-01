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
    var inviteStatus: String?
    var pendingUsers: [AppUser] = []
    var friends: [AppUser] = []
    
    var hasPendingCompetitionInvite: Bool {
        currentUser.competitionStatus == "pending"
            && currentUser.pendingCompetitionWith != nil
            && currentUser.activeCompetitionWith == nil
    }

    var pendingCompetitionFrom: String? {
        hasPendingCompetitionInvite ? currentUser.pendingCompetitionWith : nil
    }

    init(currentUser: AppUser) {
        self.currentUser = currentUser
    }

    func sendInviteTapped() {
        Task {
            do {
                try await UserService.sendInvite(from: currentUser, toUsername: usernameToInvite)
                inviteStatus = "Invite sent!"
                usernameToInvite = ""
                try await refreshUserAndReload()
            } catch {
                ErrorHandler.shared.handle(error)
                inviteStatus = nil
            }
        }
    }

    func loadData() async {
        let pendingNames = currentUser.pendingInvites
        let friendNames = currentUser.friends
        do {
            pendingUsers = try await UserService.fetchUsers(usernames: pendingNames)
            friends = try await UserService.fetchUsers(usernames: friendNames)
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }

    func accept(_ user: AppUser) {
        Task {
            do {
                try await UserService.acceptInvite(my: currentUser, from: user)
                try await refreshUserAndReload()
            } catch {
                ErrorHandler.shared.handle(error)
            }
        }
    }

    func decline(_ user: AppUser) {
        Task {
            do {
                try await UserService.declineInvite(my: currentUser, from: user)
                try await refreshUserAndReload()
            } catch {
                ErrorHandler.shared.handle(error)
            }
        }
    }

    private func refreshUserAndReload() async throws {
        let updatedUser = try await UserService.fetchUser(id: currentUser.id)
        currentUser = updatedUser
        await loadData()
    }

    @MainActor
    func toggleCompetition(with friend: AppUser) async {
        if currentUser.activeCompetitionWith == friend.name {
            currentUser.activeCompetitionWith = nil
        } else {
            currentUser.activeCompetitionWith = friend.name
        }
        do {
            try await UserService.updateCompetition(userID: currentUser.id, with: currentUser.activeCompetitionWith)
            await loadData()
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }

    @MainActor
    func inviteToCompetition(friend: AppUser) async {
        do {
            try await UserService.sendCompetitionInvite(from: currentUser.id, to: friend.id)
            await loadData()
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }

    @MainActor
    func acceptCompetitionInvite() async {
        guard let fromUserID = currentUser.pendingCompetitionWith else { return }
        do {
            let otherUser = try await UserService.fetchUser(id: fromUserID)
            try await UserService.acceptCompetitionInvite(userID: currentUser.id, friendID: otherUser.id)
            try await refreshUserAndReload()
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }

    @MainActor
    func declineCompetitionInvite() async {
        guard let fromUserID = currentUser.pendingCompetitionWith else { return }
        do {
            let otherUser = try await UserService.fetchUser(id: fromUserID)
            try await UserService.declineCompetitionInvite(userID: currentUser.id, friendID: otherUser.id)
            try await refreshUserAndReload()
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }
}
