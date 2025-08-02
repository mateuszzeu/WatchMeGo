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
    
    var pendingCompetitionChallengerName: String?
    
    var hasPendingCompetitionInvite: Bool {
        currentUser.competitionStatus == "pending"
        && currentUser.pendingCompetitionWith != nil
        && currentUser.activeCompetitionWith == nil
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
            
            if let challengerID = currentUser.pendingCompetitionWith {
                let challenger = try await UserService.fetchUser(id: challengerID)
                pendingCompetitionChallengerName = challenger.name
            } else {
                pendingCompetitionChallengerName = nil
            }
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
    
    func inviteToCompetition(friend: AppUser) async {
        do {
            try await UserService.sendCompetitionInvite(from: currentUser.id, to: friend.id)
            await loadData()
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }
    
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
    
    func isInCompetition(with friend: AppUser) -> Bool {
        currentUser.activeCompetitionWith == friend.id
    }
    
    func endCompetition(with friend: AppUser) {
        Task {
            do {
                try await UserService.endCompetition(userID: currentUser.id, friendID: friend.id)
                
                try await refreshUserAndReload()
            } catch {
                ErrorHandler.shared.handle(error)
            }
        }
    }
    
    func logout(coordinator: Coordinator) {
        do {
            try UserService.logout()
            coordinator.logout()
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }
}
