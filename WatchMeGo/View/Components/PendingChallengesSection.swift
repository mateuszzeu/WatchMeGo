//
//  PendingChallengesSection.swift
//  WatchMeGo
//
//  Created by Liza on 07/08/2025.
//

import SwiftUI

struct PendingChallengesSection: View {
    let challenges: [Challenge]
    let currentUserID: String

    private func opponentName(for challenge: Challenge) -> String {
        return challenge.senderID == currentUserID ? challenge.receiverName : challenge.senderName
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.s) {
            Text("Pending Challenges")
                .font(DesignSystem.Fonts.headline)
                .foregroundColor(DesignSystem.Colors.primary)
            if challenges.isEmpty {
                Text("No pending challenges")
                    .font(DesignSystem.Fonts.footnote)
                    .foregroundColor(DesignSystem.Colors.secondary)
            } else {
                LazyVStack(spacing: DesignSystem.Spacing.s) {
                    ForEach(challenges) { challenge in
                        HStack {
                            Text("\(challenge.name) with \(opponentName(for: challenge))")
                                .font(DesignSystem.Fonts.body)
                                .foregroundColor(DesignSystem.Colors.primary)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DesignSystem.Spacing.s)
                        .padding(.horizontal, DesignSystem.Spacing.m)
                        .background(.ultraThinMaterial)
                        .cornerRadius(DesignSystem.Radius.m)
                    }
                }
            }
        }
    }
}

#Preview {
    PendingChallengesSection(challenges: [], currentUserID: "")
        .padding()
        .background(DesignSystem.Colors.background)
}
