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

    var isAuthorized = false
    var calories = 0
    var exerciseMinutes = 0
    var standHours = 0

    var competitiveUser: AppUser? = nil
    var activeChallenge: Challenge? = nil

    var resultMessage: String? = nil
    private var didFinalize = false

    var popupMessage: String? = nil

    func loadDataAndSave(for userID: String?) async {
        isAuthorized = await HealthKitService.shared.requestAuthorization()
        guard isAuthorized else { return }

        async let cals = HealthKitService.shared.fetchTodayBurnedCalories()
        async let mins = HealthKitService.shared.fetchTodayExerciseMinutes()
        async let hours = HealthKitService.shared.fetchTodayStandHours()

        calories = await cals
        exerciseMinutes = await mins
        standHours = await hours

        await saveProgress(for: userID)

        if let userID,
           let user = try? await UserService.fetchUser(id: userID) {

            if let competitiveID = user.activeCompetitionWith {
                competitiveUser = try? await UserService.fetchUser(id: competitiveID)
                await loadActiveChallenge(for: user.id, and: competitiveID)
            } else {
                competitiveUser = nil
                activeChallenge = nil
            }
        } else {
            competitiveUser = nil
            activeChallenge = nil
        }
    }

    func handleTick(now: Date) async {
        guard let ch = activeChallenge, !didFinalize else { return }
        if remainingSeconds(from: ch.createdAt, days: ch.duration, now: now) == 0 {
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
        if let activeChallenge {
            return activeChallenge.metrics.map { $0.metric }
        } else {
            return Metric.allCases
        }
    }

    func defaultGoal(for metric: Metric) -> Int {
        switch metric {
        case .calories: return ActivityGoal.calories
        case .exerciseMinutes: return ActivityGoal.exerciseMinutes
        case .standHours: return ActivityGoal.standHours
        }
    }

    func challengeGoal(for metric: Metric) -> Int {
        let days = max(activeChallenge?.duration ?? 1, 1)
        switch metric {
        case .calories: return DailyChallengeCap.calories * days
        case .exerciseMinutes: return DailyChallengeCap.exerciseMinutes * days
        case .standHours: return DailyChallengeCap.standHours * days
        }
    }

    func remainingString(from start: Date, days: Int, now: Date) -> String {
        let seconds = remainingSeconds(from: start, days: days, now: now)
        let d = seconds / 86_400
        let h = (seconds % 86_400) / 3_600
        let m = (seconds % 3_600) / 60
        let s = seconds % 60
        if d > 0 { return "\(d)d \(h)h \(m)m \(s)s" }
        return String(format: "%02d:%02d:%02d", h, m, s)
    }

    private func remainingSeconds(from start: Date, days: Int, now: Date) -> Int {
        let end = Calendar.current.date(byAdding: .day, value: days, to: start) ?? start
        return max(0, Int(end.timeIntervalSince(now)))
    }

    private func localValue(for metric: Metric) -> Int {
        switch metric {
        case .calories: return calories
        case .exerciseMinutes: return exerciseMinutes
        case .standHours: return standHours
        }
    }

    private static let dayFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.timeZone = .current
        return df
    }()

    private func saveProgress(for userID: String?) async {
        guard let userID else { return }

        let dateString = Self.dayFormatter.string(from: Date())

        let challengeMet = calories >= ActivityGoal.calories &&
            exerciseMinutes >= ActivityGoal.exerciseMinutes &&
            standHours >= ActivityGoal.standHours

        let progress = DailyProgress(
            calories: calories,
            exerciseMinutes: exerciseMinutes,
            standHours: standHours,
            challengeMet: challengeMet
        )

        do {
            try await UserService.saveProgress(for: userID, date: dateString, progress: progress)
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }

    private func loadActiveChallenge(for meID: String, and rivalID: String) async {
        do {
            let pairID = [meID, rivalID].sorted().joined(separator: "_")
            let challenges = try await ChallengeService.fetchByPair(pairID: pairID)
            activeChallenge = challenges.first { $0.status == .active }
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }

    private func finalizeChallenge() async {
        guard let ch = activeChallenge else { return }
        didFinalize = true
        do {
            let me = try await UserService.fetchUser(id: ch.senderID == competitiveUser?.id ? ch.receiverID : ch.senderID)
            let rivalID = (me.id == ch.senderID) ? ch.receiverID : ch.senderID
            let rival = try await UserService.fetchUser(id: rivalID)

            let days = datesRangeStrings(from: ch.createdAt, durationDays: ch.duration)

            var myWins = 0, theirWins = 0, ties = 0
            for metric in displayedMetrics {
                let mySum = sum(metric, in: days, from: me.history)
                let theirSum = sum(metric, in: days, from: rival.history)
                if mySum > theirSum { myWins += 1 }
                else if mySum < theirSum { theirWins += 1 }
                else { ties += 1 }
            }

            let short: String
            if myWins > theirWins { short = "Challenge ended — winner: You! 🎉" }
            else if myWins < theirWins { short = "Challenge ended — winner: \(rival.name)! 🎉" }
            else { short = "Challenge ended — tie 🤝" }

            try await UserService.setResultMessage(userID: me.id, message: short)
            try await UserService.setResultMessage(userID: rival.id, message: short)
            popupMessage = short

            try await ChallengeService.deleteChallenge(challengeID: ch.id)
            try await UserService.endCompetition(userID: me.id, friendID: rival.id)

            activeChallenge = nil
            competitiveUser = nil
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }

    private func datesRangeStrings(from start: Date, durationDays: Int) -> [String] {
        var arr: [String] = []
        for i in 0..<durationDays {
            if let d = Calendar.current.date(byAdding: .day, value: i, to: Calendar.current.startOfDay(for: start)) {
                arr.append(Self.dayFormatter.string(from: d))
            }
        }
        return arr
    }

    private func sum(_ metric: Metric, in days: [String], from history: [String: DailyProgress]) -> Int {
        days.reduce(0) { acc, key in
            guard let dp = history[key] else { return acc }
            switch metric {
            case .calories: return acc + dp.calories
            case .exerciseMinutes: return acc + dp.exerciseMinutes
            case .standHours: return acc + dp.standHours
            }
        }
    }

    func checkResult(for userID: String?) async {
        guard let userID else { return }
        do {
            if let msg = try await UserService.consumeResultMessage(userID: userID) {
                popupMessage = msg
            }
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }
}

