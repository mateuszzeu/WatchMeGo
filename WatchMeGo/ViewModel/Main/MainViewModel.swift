//
//  MainViewModel.swift
//  WatchMeGo
//
//  Created by Liza on 19/07/2025.
//

import Foundation
import FirebaseFirestore

@MainActor
@Observable
final class MainViewModel {
    private var competitionListener: ListenerRegistration?
    var popupMessage: PopupMessage?
    
    var selectedDifficulty: Difficulty {
        get { coordinator.selectedDifficulty }
        set { coordinator.selectedDifficulty = newValue }
    }
    
    var isAuthorized = false
    var calories = 0
    var exerciseMinutes = 0
    var standHours = 0
    
    var pendingCompetitionChallengerName: String?
    var couponCompetition: Competition?
    
    var competitiveUser: AppUser?
    var activeCompetition: Competition?
    
    private var didFinalize = false
    private let coordinator: Coordinator
    
    var todaysBadge: Badge?
    var badgeCounts: (easy: Int, medium: Int, hard: Int) = (0, 0, 0)
    
    var currentUser: AppUser? {
        coordinator.currentUser
    }
    
    var hasPendingCompetitionInvite: Bool {
        couponCompetition != nil
    }
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func loadDataAndSave() async {
        isAuthorized = await HealthKitService.shared.requestAuthorization()
        guard isAuthorized else { return }
        
        do {
            try await coordinator.refreshCurrentUser()
        } catch {
            MessageHandler.shared.showError(error)
            return
        }
        
        async let caloriesValue = HealthKitService.shared.fetchTodayBurnedCalories()
        async let exerciseMinutesValue = HealthKitService.shared.fetchTodayExerciseMinutes()
        async let standHoursValue = HealthKitService.shared.fetchTodayStandHours()
        
        calories = await caloriesValue
        exerciseMinutes = await exerciseMinutesValue
        standHours = await standHoursValue
        
        await saveProgress()
        await loadBadgeCounts()
        
        await loadActiveCompetition()
        await loadCompetitionCoupon()
    }
    
    func acceptCompetitionInvite() async {
        guard let user = currentUser, let competition = couponCompetition else { return }
        
        do {
            try await CompetitionService.acceptCompetition(competitionId: competition.id)
            try await coordinator.refreshCurrentUser()
            await loadDataAndSave()
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    func declineCompetitionInvite() async {
        guard let competition = couponCompetition else { return }
        
        do {
            try await CompetitionService.declineCompetition(competitionId: competition.id)
            try await coordinator.refreshCurrentUser()
            await loadDataAndSave()
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    private func loadCompetitionCoupon() async {
        guard let user = currentUser else {
            pendingCompetitionChallengerName = nil
            couponCompetition = nil
            return
        }
        
        do {
            let pendingCompetitions = try await CompetitionService.fetchPendingCompetitions(for: user.id)
            couponCompetition = pendingCompetitions.first
            
            if let competition = couponCompetition {
                let challengerId = CompetitionService.getCompetitionPartner(for: user.id, in: competition)
                if let challengerId = challengerId {
                    let challenger = try await UserService.fetchUser(byID: challengerId)
                    pendingCompetitionChallengerName = challenger.name
                }
            }
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    private func loadActiveCompetition() async {
        competitionListener?.remove()
        
        guard let user = currentUser else {
            activeCompetition = nil
            competitiveUser = nil
            return
        }
        
        do {
            let activeCompetitions = try await CompetitionService.fetchActiveCompetitions(for: user.id)
            
            if let competition = activeCompetitions.first {
                self.activeCompetition = competition
                
                if let partnerId = CompetitionService.getCompetitionPartner(for: user.id, in: competition) {
                    self.competitiveUser = try await UserService.fetchUser(byID: partnerId)
                }
                
                self.competitionListener = CompetitionService.listenForCompetitionUpdates(competitionId: competition.id) { [weak self] updatedCompetition in
                    self?.activeCompetition = updatedCompetition
                }
            } else {
                self.activeCompetition = nil
                self.competitiveUser = nil
            }
        } catch {
            MessageHandler.shared.showError(error)
        }
    }

    private func loadBadgeCounts() async {
        guard let user = currentUser else { return }
        
        do {
            badgeCounts = try await BadgeService.getBadgeCounts(for: user.id)
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    func handleTick(now: Date) async {
        guard let competition = activeCompetition, !didFinalize else { return }
        if remainingSeconds(from: competition.startDate, days: competition.duration, now: now) == 0 {
            await finalizeCompetition()
        }
    }
    
    func value(for metric: Metric, of user: AppUser?) -> Int {
        guard let user = user else {
            return localValue(for: metric)
        }

        guard let competitionProgress = activeCompetition?.progress else {
            return 0
        }
        
        let dateString = DateFormatter.dayFormatter.string(from: Date())
        
        guard let rivalTodaysProgress = competitionProgress[user.id]?[dateString] else {
            return 0
        }

        switch metric {
        case .calories:
            return rivalTodaysProgress.calories
        case .exerciseMinutes:
            return rivalTodaysProgress.exerciseMinutes
        case .standHours:
            return rivalTodaysProgress.standHours
        }
    }
    
    var displayedMetrics: [Metric] {
        activeCompetition?.metrics ?? Metric.allCases
    }
    
    func defaultGoal(for metric: Metric) -> Int {
        switch metric {
        case .calories: return selectedDifficulty.caloriesGoal
        case .exerciseMinutes: return selectedDifficulty.exerciseMinutesGoal
        case .standHours: return selectedDifficulty.standHoursGoal
        }
    }
    
    func remainingString(from start: Date, days: Int, now: Date) -> String {
        let secondsRemaining = remainingSeconds(from: start, days: days, now: now)
        let daysRemaining = secondsRemaining / 86400
        let hoursRemaining = (secondsRemaining % 86400) / 3600
        let minutesRemaining = (secondsRemaining % 3600) / 60
        let secondsLeft = secondsRemaining % 60
        if daysRemaining > 0 {
            return "\(daysRemaining)d \(hoursRemaining)h \(minutesRemaining)m \(secondsLeft)s"
        }
        return String(format: "%02d:%02d:%02d", hoursRemaining, minutesRemaining, secondsLeft)
    }
    
    func checkResult(for userID: String?) async {
        guard let userID else { return }
        do {
            if let message = try await UserService.consumeResultMessage(forUserID: userID) {
                popupMessage = PopupMessage(text: message)
            }
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    private func remainingSeconds(from start: Date, days: Int, now: Date) -> Int {
        let endDate = Calendar.current.date(byAdding: .day, value: days, to: start) ?? start
        return max(0, Int(endDate.timeIntervalSince(now)))
    }
    
    private func localValue(for metric: Metric) -> Int {
        switch metric {
        case .calories: return calories
        case .exerciseMinutes: return exerciseMinutes
        case .standHours: return standHours
        }
    }
    
    private func saveProgress() async {
        guard let user = currentUser else { return }
        let dateString = DateFormatter.dayFormatter.string(from: Date())
        
        let progress = DailyProgress(
            calories: calories,
            exerciseMinutes: exerciseMinutes,
            standHours: standHours
        )
        
        do {
            try await ProgressService.saveProgress(for: user.id, date: dateString, progress: progress)
            
            if let newBadge = try await BadgeService.checkAndAwardBadge(
                for: user.id,
                progress: progress,
                date: dateString
            ) {
                todaysBadge = newBadge
                await loadBadgeCounts()
            }
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    private func finalizeCompetition() async {
        guard let competition = activeCompetition, let user = currentUser else { return }
        didFinalize = true
        
        do {
            let partnerId = CompetitionService.getCompetitionPartner(for: user.id, in: competition)
            guard let partnerId = partnerId else { return }
            
            let partner = try await UserService.fetchUser(byID: partnerId)
            
            let dayKeys = datesRangeStrings(from: competition.startDate, durationDays: competition.duration)
            
            let updatedCompetition = try await CompetitionService.fetchCompetition(byId: competition.id)
            guard let competitionData = updatedCompetition else { return }
            
            var myWins = 0, theirWins = 0
            for metric in displayedMetrics {
                let myHistory = competitionData.progress?[user.id] ?? [:]
                let theirHistory = competitionData.progress?[partnerId] ?? [:]
                
                let mySum = sum(metric, in: dayKeys, from: myHistory)
                let theirSum = sum(metric, in: dayKeys, from: theirHistory)
                if mySum > theirSum { myWins += 1 }
                else if mySum < theirSum { theirWins += 1 }
            }
            
            let short: String
            if myWins > theirWins { short = "Competition ended - winner: You! 🎉" }
            else if myWins < theirWins { short = "Competition ended - winner: \(partner.name)! 🎉" }
            else { short = "Competition ended - tie 🤝" }
            
            popupMessage = PopupMessage(text: short)
            
            try await UserService.setResultMessage(forUserID: partner.id, message: short)
            try await CompetitionService.endCompetition(competitionId: competition.id)
            
            activeCompetition = nil
            competitiveUser = nil
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    private func datesRangeStrings(from start: Date, durationDays: Int) -> [String] {
        var dateStrings: [String] = []
        for dayOffset in 0..<durationDays {
            if let date = Calendar.current.date(byAdding: .day, value: dayOffset, to: Calendar.current.startOfDay(for: start)) {
                dateStrings.append(DateFormatter.dayFormatter.string(from: date))
            }
        }
        return dateStrings
    }
    
    private func sum(_ metric: Metric, in days: [String], from history: [String: DailyProgress]) -> Int {
        days.reduce(0) { total, key in
            guard let dp = history[key] else { return total }
            switch metric {
            case .calories: return total + dp.calories
            case .exerciseMinutes: return total + dp.exerciseMinutes
            case .standHours: return total + dp.standHours
            }
        }
    }
}
