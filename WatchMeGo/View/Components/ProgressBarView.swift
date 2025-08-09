//
//  ProgressBarView.swift
//  WatchMeGo
//
//  Created by Liza on 19/07/2025.
//

import SwiftUI

struct ProgressBarView: View {
    let label: String
    let value: Int
    let goal: Int
    let color: Color
    let iconName: String

    private var progress: CGFloat {
        guard goal > 0 else { return 0 }
        return min(max(CGFloat(value) / CGFloat(goal), 0), 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.s) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(color)
                Text(label)
                    .font(DesignSystem.Fonts.headline)
                    .foregroundColor(color)
                Spacer()
                Text("\(value)/\(goal)")
                    .font(DesignSystem.Fonts.footnote)
                    .foregroundColor(DesignSystem.Colors.secondary)
                    .monospacedDigit()
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(color.opacity(0.15))

                    Rectangle()
                        .fill(color)
                        .frame(width: geo.size.width * progress)
                        .animation(.easeInOut(duration: 0.25), value: progress)
                }
                .clipShape(Capsule())
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text(label))
                .accessibilityValue(Text("\(value) of \(goal)"))
            }
            .frame(height: 18)
        }
        .padding(.vertical, DesignSystem.Spacing.s)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack(spacing: DesignSystem.Spacing.l) {
        ProgressBarView(
            label: "Calories",
            value: 1,
            goal: 500,
            color: DesignSystem.Colors.move,
            iconName: "flame.fill"
        )
        ProgressBarView(
            label: "Exercise Minutes",
            value: 0,
            goal: 30,
            color: DesignSystem.Colors.exercise,
            iconName: "figure.run"
        )
        ProgressBarView(
            label: "Stand Hours",
            value: 9,
            goal: 12,
            color: DesignSystem.Colors.stand,
            iconName: "clock"
        )
    }
    .padding(DesignSystem.Spacing.l)
    .frame(maxWidth: 500)
}
