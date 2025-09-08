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
    let isOpponent: Bool

    private var progress: CGFloat {
        guard goal > 0 else { return 0 }
        return min(max(CGFloat(value) / CGFloat(goal), 0), 1)
    }
    
    private var progressBarColor: Color {
        isOpponent ? DesignSystem.Colors.progressBar.darker() : DesignSystem.Colors.progressBar
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.s) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(color)
                Text(label)
                    .font(.headline)
                    .foregroundColor(DesignSystem.Colors.primary)
                Spacer()
                Text("\(value)/\(goal)")
                    .font(.footnote)
                    .foregroundColor(DesignSystem.Colors.secondary)
                    .monospacedDigit()
            }

            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(progressBarColor.opacity(0.15))

                Rectangle()
                    .fill(progressBarColor)
                    .scaleEffect(x: progress, y: 1, anchor: .leading)
                    .animation(.easeInOut(duration: 0.25), value: progress)
            }
            .clipShape(Capsule())
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text(label))
            .accessibilityValue(Text("\(value) of \(goal)"))
            .frame(height: 18)
            .frame(maxWidth: .infinity)
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
            iconName: "flame.fill",
            isOpponent: false
        )
        ProgressBarView(
            label: "Exercise Minutes",
            value: 0,
            goal: 30,
            color: DesignSystem.Colors.exercise,
            iconName: "figure.run",
            isOpponent: true
        )
        ProgressBarView(
            label: "Stand Hours",
            value: 9,
            goal: 12,
            color: DesignSystem.Colors.stand,
            iconName: "clock",
            isOpponent: false
        )
    }
    .padding(DesignSystem.Spacing.l)
    .frame(maxWidth: 500)
}
