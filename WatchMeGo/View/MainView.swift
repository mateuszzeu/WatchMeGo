//
//  MainView.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//

import SwiftUI

struct MainView: View {
    @Bindable private var viewModel = MainViewModel()
    @Bindable var coordinator: Coordinator

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.l) {
            if viewModel.isAuthorized {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.m) {
                    Text("User Progress")
                        .font(DesignSystem.Fonts.headline)
                        .foregroundColor(DesignSystem.Colors.primary)
                        .padding(.vertical, DesignSystem.Spacing.xs)
                        .padding(.horizontal, DesignSystem.Spacing.m)
                        .background(DesignSystem.Colors.surface)
                        .cornerRadius(DesignSystem.Radius.s)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)

                    ProgressBarView(label: "Calories", value: viewModel.calories, goal: 500, color: DesignSystem.Colors.move, iconName: "flame.fill")
                    ProgressBarView(label: "Exercise Minutes", value: viewModel.exerciseMinutes, goal: 80, color: DesignSystem.Colors.exercise, iconName: "figure.run")
                    ProgressBarView(label: "Stand Hours", value: viewModel.standHours, goal: 10, color: DesignSystem.Colors.stand, iconName: "clock")
                }

                if let competitive = viewModel.competitiveUser {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.m) {
                        Text("Friend Progress")
                            .font(DesignSystem.Fonts.headline)
                            .foregroundColor(DesignSystem.Colors.primary)
                            .padding(.vertical, DesignSystem.Spacing.xs)
                            .padding(.horizontal, DesignSystem.Spacing.m)
                            .background(DesignSystem.Colors.surface)
                            .cornerRadius(DesignSystem.Radius.s)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)

                        ProgressBarView(label: "Calories", value: competitive.currentProgress?.calories ?? 0, goal: 500, color: DesignSystem.Colors.move.darker(), iconName: "flame.fill")
                        ProgressBarView(label: "Exercise Minutes", value: competitive.currentProgress?.exerciseMinutes ?? 0, goal: 80, color: DesignSystem.Colors.exercise.darker(), iconName: "figure.run")
                        ProgressBarView(label: "Stand Hours", value: competitive.currentProgress?.standHours ?? 0, goal: 10, color: DesignSystem.Colors.stand.darker(), iconName: "clock")
                    }
                }
            } else {
                Text("HealthKit access required or denied.")
                    .font(DesignSystem.Fonts.body)
                    .foregroundColor(DesignSystem.Colors.primary)
            }

            Spacer()
        }
        .padding(DesignSystem.Spacing.l)
        .background(DesignSystem.Colors.background)
        .task {
            await viewModel.loadDataAndSave(for: coordinator.currentUser?.id)
        }
    }
}

#Preview {
    MainView(coordinator: Coordinator())
}
