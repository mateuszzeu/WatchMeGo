//
//  DayWinnerView.swift
//  WatchMeGo
//
//  Created by MAT on 10/09/2025.
//
import SwiftUI

struct DayWinnerView: View {
    let day: String
    let winner: String
    let isCurrentUser: Bool
    
    init(day: String, winner: String, isCurrentUser: Bool = false) {
        self.day = day
        self.winner = winner
        self.isCurrentUser = isCurrentUser
    }
    
    var body: some View {
        VStack {
            Text(day)
                .font(.caption2)
                .foregroundColor(DesignSystem.Colors.secondary)
            
            Text(winner)
                .font(.caption)
                .foregroundColor(isCurrentUser ? DesignSystem.Colors.accent : DesignSystem.Colors.primary)
        }
        .padding()
        .background(
            Capsule()
                .fill(isCurrentUser ? DesignSystem.Colors.accent.opacity(0.1) : DesignSystem.Colors.surface)
        )
    }
}
