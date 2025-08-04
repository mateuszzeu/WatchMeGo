//
//  ChallengeBannerView.swift
//  WatchMeGo
//
//  Created by Liza on 03/08/2025.
//

import SwiftUI

struct ChallengeBannerView: View {
    let username: String

    var body: some View {
        Text("\(username), find your mate!")
            .font(DesignSystem.Fonts.headline)
            .foregroundColor(DesignSystem.Colors.background)
            .frame(maxWidth: .infinity)
            .padding(.vertical, DesignSystem.Spacing.s)
            .padding(.horizontal, DesignSystem.Spacing.m)
            .background(
                Capsule()
                    .fill(DesignSystem.Colors.accent)
            )
            .padding(.top, DesignSystem.Spacing.s)
    }
}

#Preview {
    ChallengeBannerView(username: "Alex")
        .padding()
        .background(DesignSystem.Colors.background)
}
