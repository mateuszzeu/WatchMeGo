//
//  ActiveChallengeCardViewModel.swift
//  WatchMeGo
//
//  Created by MAT on 10/09/2025.
//
import Foundation

@MainActor
@Observable
final class ActiveChallengeCardViewModel {
    var currentUserProgress: Int = 0
    var competitorProgress: Int = 0
    var currentUserName: String = ""
    var competitorName: String = ""
    var dailyWinners: [DailyWinner] = []
    
    var isUserWinning: Bool {
        currentUserProgress > competitorProgress
    }
    
    func loadProgressData(for challenge: Challenge) async {
        do {
            let currentUser = try await UserService.fetchUser(byID: challenge.senderID)
            let competitor = try await UserService.fetchUser(byID: challenge.receiverID)
            
            currentUserName = currentUser.name
            competitorName = competitor.name
            
            currentUserProgress = calculatePoints(from: currentUser.currentProgress, for: challenge.metrics)
            competitorProgress = calculatePoints(from: competitor.currentProgress, for: challenge.metrics)
            
            dailyWinners = calculateDailyWinners(
                currentUser: currentUser,
                competitor: competitor,
                challenge: challenge
            )
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    private func calculatePoints(from progress: DailyProgress?, for metrics: [Challenge.MetricInfo]) -> Int {
        guard let progress = progress else { return 0 }
        
        var totalPoints = 0
        
        for metricInfo in metrics {
            switch metricInfo.metric {
            case .calories:
                totalPoints += progress.calories * 1
            case .exerciseMinutes:
                totalPoints += progress.exerciseMinutes * 10
            case .standHours:
                totalPoints += progress.standHours * 50
            }
        }
        
        return totalPoints
    }
    
    private func calculateDailyWinners(
        currentUser: AppUser,
        competitor: AppUser,
        challenge: Challenge
    ) -> [DailyWinner] {
        let dayKeys = datesRangeStrings(from: challenge.createdAt, durationDays: challenge.duration)
        var winners: [DailyWinner] = []
        let today = DateFormatter.dayFormatter.string(from: Date())
        
        for (index, dayKey) in dayKeys.enumerated() {
            guard dayKey < today else { break }
            
            let currentUserPoints = calculatePoints(from: currentUser.history[dayKey], for: challenge.metrics)
            let competitorPoints = calculatePoints(from: competitor.history[dayKey], for: challenge.metrics)
            
            let isCurrentUserWinner = currentUserPoints > competitorPoints
            let winnerName = isCurrentUserWinner ? currentUser.name : competitor.name
            
            winners.append(DailyWinner(
                day: "Day \(index + 1)",
                winnerName: winnerName,
                isCurrentUser: isCurrentUserWinner
            ))
        }
        
        return Array(winners.prefix(3))
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
