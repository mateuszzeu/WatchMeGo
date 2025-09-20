//
//  BadgeRowView.swift
//  WatchMeGo
//
//  Created by MAT on 08/09/2025.
//
import SwiftUI

struct BadgeRowView: View {
    let badgeCounts: (easy: Int, medium: Int, hard: Int)
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.s) {
            Text("Achievements")
                .font(.caption)
                .foregroundColor(DesignSystem.Colors.secondary.opacity(0.7))
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack(spacing: DesignSystem.Spacing.l) {
                Spacer()
                
                VStack(spacing: DesignSystem.Spacing.xs) {
                    BadgeView(badge: Badge(level: .easy), size: 32)
                    Text("\(badgeCounts.easy)")
                        .font(.caption.bold())
                        .foregroundColor(DesignSystem.Colors.primary)
                }
                
                VStack(spacing: DesignSystem.Spacing.xs) {
                    BadgeView(badge: Badge(level: .medium), size: 32)
                    Text("\(badgeCounts.medium)")
                        .font(.caption.bold())
                        .foregroundColor(DesignSystem.Colors.primary)
                }
                
                VStack(spacing: DesignSystem.Spacing.xs) {
                    BadgeView(badge: Badge(level: .hard), size: 32)
                    Text("\(badgeCounts.hard)")
                        .font(.caption.bold())
                        .foregroundColor(DesignSystem.Colors.primary)
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.m)
        .padding(.vertical, DesignSystem.Spacing.s)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.Radius.l)
                .fill(DesignSystem.Colors.surface)
                .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    BadgeRowView(badgeCounts: (easy: 5, medium: 3, hard: 1))
        .padding()
        .background(DesignSystem.Colors.background)
}
