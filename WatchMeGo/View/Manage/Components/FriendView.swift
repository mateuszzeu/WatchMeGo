//
//  FriendView.swift
//  WatchMeGo
//
//  Created by MAT on 20/09/2025.
//
import SwiftUI

struct FriendView: View {
    let name: String
    let showFlameIcon: Bool
    let flameIconFilled: Bool
    
    var body: some View {
        HStack {
            Circle()
                .fill(DesignSystem.Colors.accent.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(String(name.prefix(1)))
                        .font(.headline)
                        .foregroundColor(DesignSystem.Colors.accent)
                )
            
            Text(name)
                .font(.body.weight(.medium))
                .foregroundColor(DesignSystem.Colors.primary)
            
            Spacer()
            
            if showFlameIcon {
                Image(systemName: flameIconFilled ? "flame.fill" : "flame")
                    .foregroundColor(flameIconFilled ? .red : DesignSystem.Colors.secondary)
                    .font(.title3)
            }
        }
        .padding(.vertical, DesignSystem.Spacing.s)
        .padding(.horizontal, DesignSystem.Spacing.m)
        .background(DesignSystem.Colors.surface)
        .cornerRadius(DesignSystem.Radius.m)
        .shadow(color: DesignSystem.Colors.primary.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}
