//
//  CompetitionViewModel.swift
//  WatchMeGo
//
//  Created by Liza on 06/08/2025.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class CompetitionViewModel {
    private let coordinator: Coordinator
    
    var selectedFriendEmail = ""
    var competitionName = ""
    var metricSelections: [MetricSelection] = Metric.allCases.map { MetricSelection(metric: $0) }
    var competitionDurationDays = 1
    var competitionPrize = ""
    
    var activeCompetition: Competition?
    
    var currentUser: AppUser? {
        coordinator.currentUser
    }
    
    var friendEmails: [String] {
        friends.map { $0.email }
    }
    
    var friends: [AppUser] = []
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    var isReadyToSend: Bool {
        guard !selectedFriendEmail.isEmpty,
              !competitionName.isEmpty,
              metricSelections.contains(where: { $0.isSelected }),
              (1...7).contains(competitionDurationDays) else { return false }
        return true
    }
    
    func sendCompetition() async {
        guard isReadyToSend, let user = currentUser else { return }
        do {
            guard let friend = try await UserService
                .fetchUserByEmail(selectedFriendEmail) else { throw AppError.userNotFound }
            
            let selectedMetrics = metricSelections
                .filter { $0.isSelected }
                .map { $0.metric }
            
            try await CompetitionService.createCompetition(
                between: [user.id, friend.id],
                initiatorId: user.id,
                metrics: selectedMetrics,
                duration: competitionDurationDays,
                prize: competitionPrize.isEmpty ? nil : competitionPrize,
                name: competitionName
            )
            MessageHandler.shared.showSuccess("Competition invitation sent to \(friend.name)!")
            resetForm()
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    func refreshUser() async {
        do {
            try await coordinator.refreshCurrentUser()
            await loadActiveCompetitionIfExists()
            await loadFriends()
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    func loadActiveCompetitionIfExists() async {
        guard let user = currentUser else {
            activeCompetition = nil
            return
        }
        do {
            let activeCompetitions = try await CompetitionService.fetchActiveCompetitions(for: user.id)
            activeCompetition = activeCompetitions.first
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    func loadFriends() async {
        guard let user = currentUser else { return }
        do {
            friends = try await UserService.fetchFriends(for: user.id)
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    func abortActiveCompetition() async {
        guard let competition = activeCompetition else { return }
        do {
            try await CompetitionService.deleteCompetition(competitionId: competition.id)
            activeCompetition = nil
            await refreshUser()
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    private func resetForm() {
        selectedFriendEmail = ""
        competitionName = ""
        metricSelections = Metric.allCases.map { MetricSelection(metric: $0) }
        competitionDurationDays = 1
        competitionPrize = ""
    }
}
