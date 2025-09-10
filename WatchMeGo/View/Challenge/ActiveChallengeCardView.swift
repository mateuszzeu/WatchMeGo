//
//  ActiveChallengeCardView.swift
//  WatchMeGo
//
//  Created by MAT on 10/09/2025.

import SwiftUI

struct ActiveChallengeCardView: View {
    let challenge: Challenge
    let onAbortChallenge: () async -> Void
    
    @State private var currentUserProgress: Int = 1250
    @State private var competitorProgress: Int = 980
    @State private var currentUserName: String = "You"
    @State private var competitorName: String = "Kamilka"
    
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
                    Text("Last 3 Days Winners")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(DesignSystem.Colors.secondary)
                    
                    HStack(spacing: DesignSystem.Spacing.m) {
                        DayWinnerView(day: "Day 1", winner: "Kamilka")
                        DayWinnerView(day: "Day 2", winner: "You", isCurrentUser: true)
                        DayWinnerView(day: "Day 3", winner: "Kamilka")
                    }
                }
            }
            .cardStyle()
        }
    }
}
