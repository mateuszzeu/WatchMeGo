//
//  CardStyle.swift
//  WatchMeGo
//
//  Created by MAT on 22/08/2025.
//
import SwiftUI

extension View {
    func cardStyle() -> some View {
        self
            .padding(DesignSystem.Spacing.l)
            .frame(maxWidth: .infinity)
            .background(DesignSystem.Colors.surface)
            .cornerRadius(DesignSystem.Radius.l)
    }
}
