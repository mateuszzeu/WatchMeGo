//
//  ActiveCompetitionCardView.swift
//  WatchMeGo
//
//  Created by MAT on 10/09/2025.
//

import SwiftUI

struct ActiveCompetitionCardView: View {
    let competition: Competition
    let onAbortCompetition: () async -> Void
    
    @State private var viewModel = ActiveCompetitionCardViewModel()
    
    var body: some View {
        VStack {
            VStack(spacing: DesignSystem.Spacing.s) {
                Text("Active Competition")
                    .font(.headline)
                    .foregroundColor(DesignSystem.Colors.primary)
                
                Text(competition.name)
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.primary)
                    .multilineTextAlignment(.center)
                
                if !competition.metrics.isEmpty {
                    HStack(spacing: DesignSystem.Spacing.m) {
                        ForEach(competition.metrics, id: \.self) { metric in
                            VStack(spacing: DesignSystem.Spacing.xs) {
                                Image(systemName: metric.iconName)
                                    .foregroundColor(DesignSystem.Colors.accent)
                                    .font(.title3)
                                
                                Text(metric.title)
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
                        
                        Text("\(competition.duration) day\(competition.duration > 1 ? "s" : "")")
                            .font(.caption)
                            .foregroundColor(DesignSystem.Colors.secondary)
                    }
                    
                    if let prize = competition.prize, !prize.isEmpty {
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
                
                PrimaryButton(title: "Abort Competition") {
                    Task { await onAbortCompetition() }
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
                    Text("Competition History")
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
        .task(id: competition.id) {
            await viewModel.loadProgressData(for: competition)
        }
    }
}
