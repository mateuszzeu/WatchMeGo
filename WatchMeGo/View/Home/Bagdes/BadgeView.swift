//
//  BadgeView.swift
//  WatchMeGo
//
//  Created by MAT on 08/09/2025.
//

import SwiftUI

struct BadgeView: View {
    let badge: Badge?
    let size: Double
    
    init(badge: Badge?, size: Double = 40) {
        self.badge = badge
        self.size = size
    }
    
    var body: some View {
        Image(systemName: "trophy.fill")
            .font(.system(size: size * 0.6))
            .foregroundColor(badgeColor)
            .frame(width: size, height: size)
    }
    
    private var badgeColor: Color {
        guard let badge = badge else {
            return DesignSystem.Colors.secondary.opacity(0.3)
        }
        return badge.level.color
    }
}

#Preview {
    VStack(spacing: 20) {
        BadgeView(badge: Badge(level: .easy))
        BadgeView(badge: Badge(level: .medium))
        BadgeView(badge: Badge(level: .hard))
        BadgeView(badge: nil)
    }
    .padding()
    .background(DesignSystem.Colors.background)
}
