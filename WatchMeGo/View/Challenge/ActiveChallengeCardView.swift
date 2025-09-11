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
        VStack {
            VStack(spacing: DesignSystem.Spacing.s) {
                Text("Active Challenge")
                    .font(.headline)
                    .foregroundColor(DesignSystem.Colors.primary)
                
                Text(challenge.name)
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.primary)
                    .multilineTextAlignment(.center)
                
                if !challenge.metrics.isEmpty {
                    HStack(spacing: DesignSystem.Spacing.m) {
                        ForEach(challenge.metrics, id: \.metric) { metric in
                            VStack(spacing: DesignSystem.Spacing.xs) {
                                Image(systemName: metric.metric.iconName)
                                    .foregroundColor(DesignSystem.Colors.accent)
                                    .font(.title3)
                                
                                Text(metric.metric.title)
                                    .font(.caption)
                                    .foregroundColor(DesignSystem.Colors.secondary)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                }
                
                HStack(spacing: DesignSystem.Spacing.l) {
                    VStack(spacing: DesignSystem.Spacing.xs) {
                        Image(systemName: "calendar")
                            .foregroundColor(DesignSystem.Colors.secondary)
                            .font(.title3)
                        
                        Text("\(challenge.duration) day\(challenge.duration > 1 ? "s" : "")")
                            .font(.caption)
                            .foregroundColor(DesignSystem.Colors.secondary)
                    }
                    
                    if let prize = challenge.prize, !prize.isEmpty {
                        VStack(spacing: DesignSystem.Spacing.xs) {
                            Image(systemName: "gift")
                                .foregroundColor(DesignSystem.Colors.accent)
                                .font(.title3)
                            
                            Text(prize)
                                .font(.caption)
                                .foregroundColor(DesignSystem.Colors.accent)
                        }
                    }
                }
                
                PrimaryButton(title: "Abort Challenge") {
                    Task { await onAbortChallenge() }
                }
            }
            .cardStyle()
            
            VStack(spacing: DesignSystem.Spacing.m) {
                Text("Leaderboard")
                    .font(.title)
                    .foregroundColor(DesignSystem.Colors.primary)
                
                HStack(spacing: DesignSystem.Spacing.xl) {
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
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(DesignSystem.Colors.secondary)
                    
                    HStack(spacing: DesignSystem.Spacing.s) {
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
