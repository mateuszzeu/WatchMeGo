//
//  ActiveCompetitionCardViewModel.swift
//  WatchMeGo
//
//  Created by MAT on 17/09/2025.
//

import Foundation
import FirebaseAuth

@MainActor
@Observable
final class ActiveCompetitionCardViewModel {
    var currentUserProgress: Int = 0
    var competitorProgress: Int = 0
    var currentUserName: String = "You"
    var competitorName: String = "Rival"
    var dailyWinners: [DailyWinner] = []
    
    var isUserWinning: Bool {
        currentUserProgress > competitorProgress
    }
    
    func loadProgressData(for competition: Competition) async {
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let competitorId = CompetitionService.getCompetitionPartner(for: currentUserId, in: competition) else { return }

        do {
            let competitor = try await UserService.fetchUser(byID: competitorId)
            self.competitorName = competitor.name
            
            let progressMap = competition.progress ?? [:]
            let myHistory = progressMap[currentUserId] ?? [:]
            let competitorHistory = progressMap[competitorId] ?? [:]
            
            let dayKeys = datesRangeStrings(from: competition.startDate, durationDays: competition.duration)
            
            self.currentUserProgress = sumTotalPoints(from: myHistory, for: competition.metrics, over: dayKeys)
            self.competitorProgress = sumTotalPoints(from: competitorHistory, for: competition.metrics, over: dayKeys)
            
            self.dailyWinners = calculateDailyWinners(
                myHistory: myHistory,
                competitorHistory: competitorHistory,
                competitorName: competitor.name,
                metrics: competition.metrics,
                dayKeys: dayKeys
            )
            
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    private func sumTotalPoints(from history: [String: DailyProgress], for metrics: [Metric], over days: [String]) -> Int {
        var totalPoints = 0
        for day in days {
            if let dailyProgress = history[day] {
                totalPoints += calculatePoints(from: dailyProgress, for: metrics)
            }
        }
        return totalPoints
    }
    
    private func calculatePoints(from progress: DailyProgress?, for metrics: [Metric]) -> Int {
        guard let progress = progress else { return 0 }
        
        var totalPoints = 0
        for metric in metrics {
            switch metric {
            case .calories:
                totalPoints += progress.calories
            case .exerciseMinutes:
                totalPoints += progress.exerciseMinutes * 10
            case .standHours:
                totalPoints += progress.standHours * 50
            }
        }
        return totalPoints
    }
    
    private func calculateDailyWinners(myHistory: [String: DailyProgress], competitorHistory: [String: DailyProgress], competitorName: String, metrics: [Metric], dayKeys: [String]) -> [DailyWinner] {
        var winners: [DailyWinner] = []
        let today = DateFormatter.dayFormatter.string(from: Date())
        
        for (index, dayKey) in dayKeys.enumerated() {
            guard dayKey < today else { break }
            
            let currentUserPoints = calculatePoints(from: myHistory[dayKey], for: metrics)
            let competitorPoints = calculatePoints(from: competitorHistory[dayKey], for: metrics)
            
            let isCurrentUserWinner = currentUserPoints > competitorPoints
            let winnerName = isCurrentUserWinner ? "You" : competitorName
            
            winners.append(DailyWinner(
                day: "Day \(index + 1)",
                winnerName: winnerName,
                isCurrentUser: isCurrentUserWinner
            ))
        }
        return Array(winners.prefix(7))
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
}
