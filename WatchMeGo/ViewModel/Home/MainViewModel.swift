//
//  MainViewModel.swift
//  WatchMeGo
//
//  Created by Liza on 19/07/2025.
//

import Foundation

@MainActor
@Observable
final class MainViewModel {
    
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
    var couponChallenge: Challenge?
    
    var competitiveUser: AppUser?
    var activeChallenge: Challenge?
    
    private var didFinalize = false
    private let coordinator: Coordinator
    
    var todaysBadge: Badge?
    
    var badgeCounts: (easy: Int, medium: Int, hard: Int) {
        guard let user = currentUser else { return (easy: 0, medium: 0, hard: 0) }
        return BadgeService.getBadgeCounts(for: user)
    }
    
    var currentUser: AppUser? {
        coordinator.currentUser
    }
    
    var hasPendingCompetitionInvite: Bool {
        guard let user = currentUser else { return false }
        return user.competitionStatus == "pendingReceived"
        && user.pendingCompetitionWith != nil
        && user.activeCompetitionWith == nil
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
        
        if let competitiveID = currentUser?.activeCompetitionWith {
            competitiveUser = try? await UserService.fetchUser(byID: competitiveID)
            await loadActiveChallenge(for: currentUser!.id, and: competitiveID)
        } else {
            competitiveUser = nil
            activeChallenge = nil
        }
        
        await loadCompetitionCoupon()
    }
    
    func acceptCompetitionInvite() async {
        guard
            let user = currentUser,
            let fromUserID = user.pendingCompetitionWith,
            let challengeID = couponChallenge?.id
        else { return }
        
        do {
            try await UserService.acceptCompetitionInvite(userID: user.id, friendID: fromUserID)
            try await ChallengeService.setChallengeStatus(challengeID: challengeID, to: .active)
            try await coordinator.refreshCurrentUser()
            await loadDataAndSave()
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    func declineCompetitionInvite() async {
        guard let user = currentUser, let fromUserID = user.pendingCompetitionWith else { return }
        do {
            try await UserService.declineCompetitionInvite(userID: user.id, friendID: fromUserID)
            try await coordinator.refreshCurrentUser()
            await loadDataAndSave()
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    private func loadCompetitionCoupon() async {
        guard let user = currentUser, let challengerID = user.pendingCompetitionWith else {
            pendingCompetitionChallengerName = nil
            couponChallenge = nil
            return
        }
        
        do {
            let challenger = try await UserService.fetchUser(byID: challengerID)
            pendingCompetitionChallengerName = challenger.name
            
            let pairID = [user.id, challengerID].sorted().joined(separator: "_")
            let challenges = try await ChallengeService.fetchChallengesByPair(pairID: pairID)
            couponChallenge = challenges.first(where: { $0.status == .pending })
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    func handleTick(now: Date) async {
        guard let challenge = activeChallenge, !didFinalize else { return }
        if remainingSeconds(from: challenge.createdAt, days: challenge.duration, now: now) == 0 {
            await finalizeChallenge()
        }
    }
    
    func value(for metric: Metric, of user: AppUser?) -> Int {
        guard let user else { return localValue(for: metric) }
        switch metric {
        case .calories: return user.currentProgress?.calories ?? 0
        case .exerciseMinutes: return user.currentProgress?.exerciseMinutes ?? 0
        case .standHours: return user.currentProgress?.standHours ?? 0
        }
    }
    
    var displayedMetrics: [Metric] {
        activeChallenge?.metrics.map { $0.metric } ?? Metric.allCases
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
        
        let challengeMet =
        calories >= selectedDifficulty.caloriesGoal &&
        exerciseMinutes >= selectedDifficulty.exerciseMinutesGoal &&
        standHours >= selectedDifficulty.standHoursGoal
        
        let progress = DailyProgress(
            calories: calories,
            exerciseMinutes: exerciseMinutes,
            standHours: standHours,
            challengeMet: challengeMet
        )
        
        do {
            try await UserService.saveProgress(forUserID: user.id, date: dateString, progress: progress)
            
            if let newBadge = try await BadgeService.checkAndAwardBadge(
                for: user.id,
                progress: progress,
                date: dateString
            ) {
                todaysBadge = newBadge
                try await coordinator.refreshCurrentUser()
            }
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    private func loadActiveChallenge(for myUserID: String, and rivalID: String) async {
        do {
            let pairID = [myUserID, rivalID].sorted().joined(separator: "_")
            let challenges = try await ChallengeService.fetchChallengesByPair(pairID: pairID)
            activeChallenge = challenges.first { $0.status == .active }
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    private func finalizeChallenge() async {
        guard let challenge = activeChallenge, currentUser != nil else { return }
        didFinalize = true
        do {
            let me = try await UserService.fetchUser(
                byID: challenge.senderID == competitiveUser?.id ? challenge.receiverID : challenge.senderID
            )
            let rivalID = (me.id == challenge.senderID) ? challenge.receiverID : challenge.senderID
            let rival = try await UserService.fetchUser(byID: rivalID)
            
            let dayKeys = datesRangeStrings(from: challenge.createdAt, durationDays: challenge.duration)
            
            var myWins = 0, theirWins = 0
            for metric in displayedMetrics {
                let mySum = sum(metric, in: dayKeys, from: me.history)
                let theirSum = sum(metric, in: dayKeys, from: rival.history)
                if mySum > theirSum { myWins += 1 }
                else if mySum < theirSum { theirWins += 1 }
            }
            
            let short: String
            if myWins > theirWins { short = "Challenge ended - winner: You! 🎉" }
            else if myWins < theirWins { short = "Challenge ended - winner: \(rival.name)! 🎉" }
            else { short = "Challenge ended - tie 🤝" }
            
            popupMessage = PopupMessage(text: short)
            
            try await UserService.setResultMessage(forUserID: rival.id, message: short)
            
            try await ChallengeService.deleteChallenge(challengeID: challenge.id)
            try await UserService.endCompetition(userID: me.id, friendID: rival.id)
            
            activeChallenge = nil
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
