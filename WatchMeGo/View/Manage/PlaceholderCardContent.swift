//
//  PlaceholderCardContent.swift
//  WatchMeGo
//
//  Created by MAT on 20/08/2025.
//

import SwiftUI

struct PlaceholderCardContent: View {
    let systemImage: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.s) {
            Image(systemName: systemImage)
                .font(.system(size: 36, weight: .semibold))
                .foregroundColor(DesignSystem.Colors.secondary)
            Text(title)
                .font(DesignSystem.Fonts.body)
                .foregroundColor(DesignSystem.Colors.primary)
            Text(subtitle)
                .font(DesignSystem.Fonts.footnote)
                .foregroundColor(DesignSystem.Colors.secondary)
                .multilineTextAlignment(.center)
        }
        //.frame(maxWidth: .infinity)
        .padding(.vertical, DesignSystem.Spacing.m)
    }
}
