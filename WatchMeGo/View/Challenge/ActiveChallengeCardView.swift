//
//  ActiveChallengeCardView.swift
//  WatchMeGo
//
//  Created by MAT on 10/09/2025.
//
import SwiftUI

struct ActiveChallengeCardView: View {
    let challenge: Challenge
    let onAbortChallenge: () async -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.l) {
            Text("Active Challenge")
                .font(.headline)
                .foregroundColor(DesignSystem.Colors.primary)
            
            VStack(spacing: DesignSystem.Spacing.m) {
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
            }
            .cardStyle()
            
            PrimaryButton(title: "Abort Challenge") {
                Task { await onAbortChallenge() }
            }
        }
        .cardStyle()
    }
}
