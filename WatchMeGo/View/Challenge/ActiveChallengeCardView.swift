//
//  ActiveChallengeCardView.swift
//  WatchMeGo
//
//  Created by MAT on 10/09/2025.

import SwiftUI

struct ActiveChallengeCardView: View {
    let challenge: Challenge
    let onAbortChallenge: () async -> Void
    
    @State private var viewModel = ActiveChallengeCardViewModel()
    
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
                        name: viewModel.isUserWinning ? viewModel.currentUserName : viewModel.competitorName,
                        progress: viewModel.isUserWinning ? viewModel.currentUserProgress : viewModel.competitorProgress,
                        isWinning: true
                    )
                    
                    ProgressColumnView(
                        name: viewModel.isUserWinning ? viewModel.competitorName : viewModel.currentUserName,
                        progress: viewModel.isUserWinning ? viewModel.competitorProgress : viewModel.currentUserProgress,
                        isWinning: false
                    )
                }
                
                VStack(spacing: DesignSystem.Spacing.s) {
                    Text("Challenge History")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(DesignSystem.Colors.secondary)
                    
                    HStack(spacing: DesignSystem.Spacing.m) {
                        ForEach(viewModel.dailyWinners, id: \.day) { dailyWinner in
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
        .task(id: challenge.id) {
            await viewModel.loadProgressData(for: challenge)
        }
    }
}
