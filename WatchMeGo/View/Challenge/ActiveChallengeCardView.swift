//
//  ActiveChallengeCardView.swift
//  WatchMeGo
//
//  Created by MAT on 10/09/2025.

import SwiftUI

struct ActiveChallengeCardView: View {
    let challenge: Challenge
    let onAbortChallenge: () async -> Void
    
    @State private var currentUserProgress: Int = 0
    @State private var competitorProgress: Int = 0
    @State private var currentUserName: String = ""
    @State private var competitorName: String = ""
    @State private var dailyWinners: [DailyWinner] = []
    
    private var isUserWinning: Bool {
        currentUserProgress > competitorProgress
    }
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.m) {
            VStack(spacing: DesignSystem.Spacing.s) {
                Text("Active Challenge")
                    .font(.headline)
                    .foregroundColor(DesignSystem.Colors.primary)
                
                Text(challenge.name)
                    .font(.body)
                    .foregroundColor(DesignSystem.Colors.primary)
                    .multilineTextAlignment(.center)
                
                if !challenge.metrics.isEmpty {
                    Text(challenge.metrics.map { $0.metric.title }.joined(separator: " • "))
                        .font(.footnote)
                        .foregroundColor(DesignSystem.Colors.secondary)
                        .multilineTextAlignment(.center)
                }
                
                Text("Duration: \(challenge.duration) day\(challenge.duration > 1 ? "s" : "")")
                    .font(.footnote)
                    .foregroundColor(DesignSystem.Colors.secondary)
                    .multilineTextAlignment(.center)
                
                if let prize = challenge.prize, !prize.isEmpty {
                    Text("Prize: \(prize)")
                        .font(.footnote)
                        .foregroundColor(DesignSystem.Colors.secondary)
                        .multilineTextAlignment(.center)
                }
                
                PrimaryButton(title: "Abort Challenge") {
                    Task { await onAbortChallenge() }
                }
            }
            .cardStyle()
            
            VStack(spacing: DesignSystem.Spacing.l) {
                Text("Leaderboard")
                    .font(.title)
                    .foregroundColor(DesignSystem.Colors.primary)
                
                HStack(spacing: DesignSystem.Spacing.l) {
                    ProgressColumnView(
                        name: isUserWinning ? currentUserName : competitorName,
                        progress: isUserWinning ? currentUserProgress : competitorProgress,
                        isWinning: true
                    )
                    
                    ProgressColumnView(
                        name: isUserWinning ? competitorName : currentUserName,
                        progress: isUserWinning ? competitorProgress : currentUserProgress,
                        isWinning: false
                    )
                }
                
                VStack(spacing: DesignSystem.Spacing.s) {
                    Text("Challenge History")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(DesignSystem.Colors.secondary)
                    
                    HStack(spacing: DesignSystem.Spacing.m) {
                        ForEach(dailyWinners, id: \.day) { dailyWinner in
                            DayWinnerView(
                                day: dailyWinner.day,
                                winner: dailyWinner.winnerName,
                                isCurrentUser: dailyWinner.isCurrentUser
                            )
                        }
                    }
                }
            }
            .cardStyle()
        }
        .task {
            await loadProgressData()
        }
    }
    
    private func loadProgressData() async {
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

struct DailyWinner {
    let day: String
    let winnerName: String
    let isCurrentUser: Bool
}
