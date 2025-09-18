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
            
            Circle()
                .fill(isCurrentUser ? DesignSystem.Colors.accent : DesignSystem.Colors.primary)
                .frame(width: 32, height: 32)
                .overlay(
                    Text(winner.prefix(1))
                        .font(.caption.weight(.bold))
                        .foregroundColor(DesignSystem.Colors.surface)
                )
        }
    }
}
