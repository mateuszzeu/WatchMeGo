//
//  CompetitionCouponView.swift
//  WatchMeGo
//
//  Created by Liza on 03/08/2025.
//

import SwiftUI

struct CompetitionCouponView: View {
    let challenger: String
    let onAccept: () -> Void
    let onDecline: () -> Void
    @State private var appear = false

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.m) {
            Text("\(challenger) invited you to a competition!")
                .font(DesignSystem.Fonts.headline)
                .foregroundColor(DesignSystem.Colors.primary)
                .multilineTextAlignment(.center)
            HStack(spacing: DesignSystem.Spacing.m) {
                Button("Accept", action: onAccept)
                    .buttonStyle(.borderedProminent)
                    .tint(DesignSystem.Colors.accent)
                Button("Decline", action: onDecline)
                    .buttonStyle(.bordered)
                    .tint(DesignSystem.Colors.error)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(DesignSystem.Spacing.m)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .cornerRadius(DesignSystem.Radius.l)
        .shadow(radius: DesignSystem.Radius.s)
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Radius.l)
                .stroke(
                    LinearGradient(
                        colors: [DesignSystem.Colors.accent, DesignSystem.Colors.error],
                        startPoint: .leading,
                        endPoint: .trailing
                    ), lineWidth: 3
                )
        )
        .scaleEffect(appear ? 1 : 0.95)
        .opacity(appear ? 1 : 0)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: appear)
        .onAppear { appear = true }
    }
}

#Preview {
    CompetitionCouponView(challenger: "Jane", onAccept: {}, onDecline: {})
        .padding()
        .background(DesignSystem.Colors.background)
}
