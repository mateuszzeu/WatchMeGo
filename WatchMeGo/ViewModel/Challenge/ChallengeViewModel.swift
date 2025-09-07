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
    private let coordinator: Coordinator
    
    var selectedFriendUsername = ""
    var challengeName = ""
    var metricSelections: [MetricSelection] = Metric.allCases.map { MetricSelection(metric: $0) }
    var challengeDurationDays = 1
    var challengePrize = ""
    
    var activeChallenge: Challenge?
    
    var currentUser: AppUser? {
        coordinator.currentUser
    }
    
    var friendUsernames: [String] { 
        currentUser?.friends ?? []
    }
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    var isReadyToSend: Bool {
        guard !selectedFriendUsername.isEmpty,
              !challengeName.isEmpty,
              metricSelections.contains(where: { $0.isSelected }),
              (1...7).contains(challengeDurationDays) else { return false }
        return true
    }
    
    func sendChallenge() async {
        guard isReadyToSend, let user = currentUser else { return }
        do {
            guard let friend = try await UserService
                .fetchUsers(byUsernames: [selectedFriendUsername])
                .first else { throw AppError.userNotFound }
            
            let pairID = [user.id, friend.id].sorted().joined(separator: "_")
            let challengeID = UUID().uuidString
            
            let selectedMetrics = metricSelections
                .filter { $0.isSelected }
                .map { Challenge.MetricInfo(metric: $0.metric, target: nil) }
            
            let newChallenge = Challenge(
                id: challengeID,
                pairID: pairID,
                name: challengeName,
                senderID: user.id,
                senderName: user.name,
                receiverID: friend.id,
                receiverName: friend.name,
                mode: .versus,
                metrics: selectedMetrics,
                duration: challengeDurationDays,
                prize: challengePrize.isEmpty ? nil : challengePrize,
                status: .pending,
                createdAt: Date()
            )
            
            try await UserService.sendCompetitionInvite(fromUserID: user.id, toFriendID: friend.id)
            try await ChallengeService.createChallenge(newChallenge)
            resetForm()
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    func refreshUser() async {
        do {
            try await coordinator.refreshCurrentUser()
            await loadActiveChallengeIfExists()
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    func loadActiveChallengeIfExists() async {
        guard let user = currentUser, let opponentID = user.activeCompetitionWith else {
            activeChallenge = nil
            return
        }
        do {
            let pairID = [user.id, opponentID].sorted().joined(separator: "_")
            let challenges = try await ChallengeService.fetchChallengesByPair(pairID: pairID)
            activeChallenge = challenges.first(where: { $0.status == .active })
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    func abortActiveChallenge() async {
        guard let challenge = activeChallenge, let user = currentUser else { return }
        do {
            try await ChallengeService.deleteChallenge(challengeID: challenge.id)
            if let opponentID = user.activeCompetitionWith {
                try await UserService.endCompetition(userID: user.id, friendID: opponentID)
            }
            activeChallenge = nil
            await refreshUser()
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    private func resetForm() {
        selectedFriendUsername = ""
        challengeName = ""
        metricSelections = Metric.allCases.map { MetricSelection(metric: $0) }
        challengeDurationDays = 1
        challengePrize = ""
    }
}
