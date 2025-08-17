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
    var couponChallenge: Challenge?

    var hasPendingCompetitionInvite: Bool {
        currentUser.competitionStatus == "pendingReceived"
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
                try await reloadUserAndData()
            } catch {
                ErrorHandler.shared.handle(error)
                inviteStatus = nil
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

            try await loadCompetitionCoupon()
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }

    func accept(_ user: AppUser) {
        Task {
            do {
                try await UserService.acceptInvite(my: currentUser, from: user)
                try await reloadUserAndData()
            } catch {
                ErrorHandler.shared.handle(error)
            }
        }
    }

    func decline(_ user: AppUser) {
        Task {
            do {
                try await UserService.declineInvite(my: currentUser, from: user)
                try await reloadUserAndData()
            } catch {
                ErrorHandler.shared.handle(error)
            }
        }
    }

    func acceptCompetitionInvite() async {
        guard
            let fromUserID = currentUser.pendingCompetitionWith,
            let challengeID = couponChallenge?.id
        else { return }

        do {
            try await UserService.acceptCompetitionInvite(userID: currentUser.id, friendID: fromUserID)
            try await ChallengeService.setChallengeStatus(challengeID: challengeID, to: .active)
            try await reloadUserAndData()
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }

    func declineCompetitionInvite() async {
        guard let fromUserID = currentUser.pendingCompetitionWith else { return }
        do {
            try await UserService.declineCompetitionInvite(userID: currentUser.id, friendID: fromUserID)
            try await reloadUserAndData()
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }

    func isInCompetition(with friend: AppUser) -> Bool {
        currentUser.activeCompetitionWith == friend.id
    }

    func logout(coordinator: Coordinator) {
        do {
            try UserService.logout()
            coordinator.logout()
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }
    
    func resetPassword() async {
        do {
            try await UserService.resetPassword(email: currentUser.email)
            // Note: Firebase will send the reset email automatically
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }

    private func loadCompetitionCoupon() async throws {
        guard let challengerID = currentUser.pendingCompetitionWith else {
            pendingCompetitionChallengerName = nil
            couponChallenge = nil
            return
        }

        let challenger = try await UserService.fetchUser(byID: challengerID)
        pendingCompetitionChallengerName = challenger.name

        let pairID = [currentUser.id, challengerID].sorted().joined(separator: "_")
        let challenges = try await ChallengeService.fetchChallengesByPair(pairID: pairID)
        couponChallenge = challenges.first(where: { $0.status == .pending })
    }

    private func reloadUserAndData() async throws {
        currentUser = try await UserService.fetchUser(byID: currentUser.id)
        await loadData()
    }
}
