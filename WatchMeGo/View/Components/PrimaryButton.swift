//
//  PrimaryButton.swift
//  WatchMeGo
//
//  Created by Liza on 03/08/2025.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var color: Color = DesignSystem.Colors.accent

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(DesignSystem.Colors.background)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignSystem.Spacing.s)
                .background(color)
                .cornerRadius(DesignSystem.Radius.m)
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
        .shadow(radius: DesignSystem.Radius.s, y: DesignSystem.Spacing.xs)
    }
}
