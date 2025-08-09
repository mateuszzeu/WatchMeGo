//
//  ChallengeViewModel.swift
//  WatchMeGo
//
//  Created by Liza on 06/08/2025.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class ChallengeViewModel {
    private(set) var currentUser: AppUser

    var onUserRefreshed: ((AppUser) -> Void)?

    var selectedFriend = ""
    var name = ""
    var metrics: [MetricSelection] = Metric.allCases.map { MetricSelection(metric: $0) }
    var duration = 1
    var prize = ""

    var activeChallenge: Challenge?

    var availableFriends: [String] {
        currentUser.friends
    }

    init(currentUser: AppUser) {
        self.currentUser = currentUser
    }

    var canSend: Bool {
        guard !selectedFriend.isEmpty,
              !name.isEmpty,
              metrics.contains(where: { $0.isSelected }),
              (1...7).contains(duration) else { return false }
        return true
    }

    func sendChallenge() {
        guard canSend else { return }
        Task {
            do {
                guard let friend = try await UserService
                    .fetchUsers(usernames: [selectedFriend])
                    .first else { throw AppError.userNotFound }

                let pairID = [currentUser.id, friend.id].sorted().joined(separator: "_")
                let challengeID = UUID().uuidString

                let selectedMetrics = metrics
                    .filter { $0.isSelected }
                    .map { Challenge.MetricInfo(metric: $0.metric, target: nil) }

                let challenge = Challenge(
                    id: challengeID,
                    pairID: pairID,
                    name: name,
                    senderID: currentUser.id,
                    senderName: currentUser.name,
                    receiverID: friend.id,
                    receiverName: friend.name,
                    mode: .versus,
                    metrics: selectedMetrics,
                    duration: duration,
                    prize: prize.isEmpty ? nil : prize,
                    status: .pending,
                    createdAt: Date()
                )

                try await UserService.sendCompetitionInvite(from: currentUser.id, to: friend.id)
                try await ChallengeService.createChallenge(challenge)
                resetForm()
            } catch {
                ErrorHandler.shared.handle(error)
            }
        }
    }

    func refreshUser() async {
        do {
            let updated = try await UserService.fetchUser(id: currentUser.id)
            currentUser = updated
            onUserRefreshed?(updated)
            await loadActiveChallengeIfAny()
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }

    func loadActiveChallengeIfAny() async {
        guard let opponentID = currentUser.activeCompetitionWith else {
            activeChallenge = nil
            return
        }
        do {
            let pairID = [currentUser.id, opponentID].sorted().joined(separator: "_")
            let challenges = try await ChallengeService.fetchByPair(pairID: pairID)
            activeChallenge = challenges.first(where: { $0.status == .active })
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }

    func abortActiveChallenge() {
        guard let ch = activeChallenge else { return }
        Task {
            do {
                try await ChallengeService.deleteChallenge(challengeID: ch.id)
                if let opponent = currentUser.activeCompetitionWith {
                    try await UserService.endCompetition(userID: currentUser.id, friendID: opponent)
                }
                await refreshUser() // zaktualizuje Coordinator przez onUserRefreshed
            } catch {
                ErrorHandler.shared.handle(error)
            }
        }
    }

    private func resetForm() {
        selectedFriend = ""
        name = ""
        metrics = Metric.allCases.map { MetricSelection(metric: $0) }
        duration = 1
        prize = ""
    }
}
