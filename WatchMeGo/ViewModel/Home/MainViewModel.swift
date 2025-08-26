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
    
    private enum ActivityGoal {
        static let calories = 500
        static let exerciseMinutes = 80
        static let standHours = 10
    }
    
    private enum DailyChallengeCap {
        static let calories = 1500
        static let exerciseMinutes = 250
        static let standHours = 20
    }
    
    var popupMessage: PopupMessage?
    
    var isAuthorized = false
    var calories = 0
    var exerciseMinutes = 0
    var standHours = 0
    
    var pendingCompetitionChallengerName: String?
    var couponChallenge: Challenge?
    
    var competitiveUser: AppUser?
    var activeChallenge: Challenge?
    
    private var didFinalize = false
    private(set) var currentUser: AppUser
    
    var hasPendingCompetitionInvite: Bool {
        currentUser.competitionStatus == "pendingReceived"
        && currentUser.pendingCompetitionWith != nil
        && currentUser.activeCompetitionWith == nil
    }
    
    init(currentUser: AppUser) {
        self.currentUser = currentUser
    }
    
    func loadDataAndSave() async {
        isAuthorized = await HealthKitService.shared.requestAuthorization()
        guard isAuthorized else { return }
        
        do {
            currentUser = try await UserService.fetchUser(byID: currentUser.id)
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
        
        if let competitiveID = currentUser.activeCompetitionWith {
            competitiveUser = try? await UserService.fetchUser(byID: competitiveID)
            await loadActiveChallenge(for: currentUser.id, and: competitiveID)
        } else {
            competitiveUser = nil
            activeChallenge = nil
        }
        
        await loadCompetitionCoupon()
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
            MessageHandler.shared.showError(error)
        }
    }
    
    func declineCompetitionInvite() async {
        guard let fromUserID = currentUser.pendingCompetitionWith else { return }
        do {
            try await UserService.declineCompetitionInvite(userID: currentUser.id, friendID: fromUserID)
            try await reloadUserAndData()
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    private func loadCompetitionCoupon() async {
        guard let challengerID = currentUser.pendingCompetitionWith else {
            pendingCompetitionChallengerName = nil
            couponChallenge = nil
            return
        }
        
        do {
            let challenger = try await UserService.fetchUser(byID: challengerID)
            pendingCompetitionChallengerName = challenger.name
            
            let pairID = [currentUser.id, challengerID].sorted().joined(separator: "_")
            let challenges = try await ChallengeService.fetchChallengesByPair(pairID: pairID)
            couponChallenge = challenges.first(where: { $0.status == .pending })
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    private func reloadUserAndData() async throws {
        currentUser = try await UserService.fetchUser(byID: currentUser.id)
        await loadDataAndSave()
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
        case .calories: return ActivityGoal.calories
        case .exerciseMinutes: return ActivityGoal.exerciseMinutes
        case .standHours: return ActivityGoal.standHours
        }
    }
    
    func challengeGoal(for metric: Metric) -> Int {
        let days = activeChallenge?.duration ?? 1
        switch metric {
        case .calories: return DailyChallengeCap.calories * days
        case .exerciseMinutes: return DailyChallengeCap.exerciseMinutes * days
        case .standHours: return DailyChallengeCap.standHours * days
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
    
    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current
        return formatter
    }()
    
    private func saveProgress() async {
        let dateString = Self.dayFormatter.string(from: Date())
        
        let challengeMet =
        calories >= ActivityGoal.calories &&
        exerciseMinutes >= ActivityGoal.exerciseMinutes &&
        standHours >= ActivityGoal.standHours
        
        let progress = DailyProgress(
            calories: calories,
            exerciseMinutes: exerciseMinutes,
            standHours: standHours,
            challengeMet: challengeMet
        )
        
        do {
            try await UserService.saveProgress(forUserID: currentUser.id, date: dateString, progress: progress)
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
        guard let challenge = activeChallenge else { return }
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
                dateStrings.append(Self.dayFormatter.string(from: date))
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
