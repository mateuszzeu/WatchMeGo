//
//  PorgressBarView.swift
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

    var progress: Double {
        guard goal > 0 else { return 0 }
        return min(Double(value) / Double(goal), 1.0)
    }

    var body: some View {
        VStack {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(color)
                Text(label)
                    .font(.headline)
                    .foregroundColor(color)
                Spacer()
                Text("\(value)/\(goal)")
                    .foregroundColor(.secondary)
            }
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(color.opacity(0.15))
                    .frame(height: 18)
                Capsule()
                    .fill(color)
                    .frame(width: CGFloat(progress) * UIScreen.main.bounds.width * 0.7, height: 20)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity)
    }
}





#Preview {
    VStack(spacing: 20) {
        ProgressBarView(label: "Calories", value: 320, goal: 500, color: .red, iconName: "flame.fill")
        ProgressBarView(label: "Exercise Minutes", value: 18, goal: 30, color: .green, iconName: "figure.run")
        ProgressBarView(label: "Stand Hours", value: 9, goal: 12, color: .blue, iconName: "clock")
    }
    .padding()
    .frame(maxWidth: 500)
}
