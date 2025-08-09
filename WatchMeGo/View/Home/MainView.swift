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

    @State private var now = Date()
    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.l) {
            if viewModel.isAuthorized {

                if let rival = viewModel.competitiveUser, let challenge = viewModel.activeChallenge {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.m) {

                        VStack(spacing: 4) {
                            Text("Time left")
                                .font(DesignSystem.Fonts.footnote)
                                .foregroundColor(DesignSystem.Colors.secondary)
                            HStack(spacing: DesignSystem.Spacing.s) {
                                Image(systemName: "timer")
                                    .foregroundColor(DesignSystem.Colors.accent)
                                Text(viewModel.remainingString(from: challenge.createdAt,
                                                               days: challenge.duration,
                                                               now: now))
                                    .font(DesignSystem.Fonts.headline)
                                    .foregroundColor(DesignSystem.Colors.primary)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DesignSystem.Spacing.xs)
                        .padding(.horizontal, DesignSystem.Spacing.m)
                        .background(.ultraThinMaterial)
                        .cornerRadius(DesignSystem.Radius.s)
                        .onReceive(ticker) { t in
                            now = t
                            Task { await viewModel.handleTick(now: t) }
                        }

                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.m) {
                            Text("\(coordinator.currentUser?.name ?? "You") — today")
                                .font(DesignSystem.Fonts.headline)
                                .foregroundColor(DesignSystem.Colors.primary)
                                .padding(.vertical, DesignSystem.Spacing.xs)
                                .padding(.horizontal, DesignSystem.Spacing.m)
                                .background(.ultraThinMaterial)
                                .cornerRadius(DesignSystem.Radius.s)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)

                            ForEach(viewModel.displayedMetrics) { metric in
                                ProgressBarView(
                                    label: metric.title,
                                    value: viewModel.value(for: metric, of: nil),
                                    goal: viewModel.challengeGoal(for: metric),
                                    color: {
                                        switch metric {
                                        case .calories: return DesignSystem.Colors.move
                                        case .exerciseMinutes: return DesignSystem.Colors.exercise
                                        case .standHours: return DesignSystem.Colors.stand
                                        }
                                    }(),
                                    iconName: metric.iconName
                                )
                            }
                        }

                        Divider()
                            .frame(height: 1)
                            .background(DesignSystem.Colors.secondary)
                            .padding(.vertical, DesignSystem.Spacing.m)

                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.m) {
                            Text("\(rival.name) — today")
                                .font(DesignSystem.Fonts.headline)
                                .foregroundColor(DesignSystem.Colors.primary)
                                .padding(.vertical, DesignSystem.Spacing.xs)
                                .padding(.horizontal, DesignSystem.Spacing.m)
                                .background(.ultraThinMaterial)
                                .cornerRadius(DesignSystem.Radius.s)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)

                            ForEach(viewModel.displayedMetrics) { metric in
                                ProgressBarView(
                                    label: metric.title,
                                    value: viewModel.value(for: metric, of: rival),
                                    goal: viewModel.challengeGoal(for: metric),
                                    color: {
                                        switch metric {
                                        case .calories: return DesignSystem.Colors.move.darker()
                                        case .exerciseMinutes: return DesignSystem.Colors.exercise.darker()
                                        case .standHours: return DesignSystem.Colors.stand.darker()
                                        }
                                    }(),
                                    iconName: metric.iconName
                                )
                            }
                        }
                    }

                } else {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.m) {
                        Text("\(coordinator.currentUser?.name ?? "User") Progress")
                            .font(DesignSystem.Fonts.headline)
                            .foregroundColor(DesignSystem.Colors.primary)
                            .padding(.vertical, DesignSystem.Spacing.xs)
                            .padding(.horizontal, DesignSystem.Spacing.m)
                            .background(.ultraThinMaterial)
                            .cornerRadius(DesignSystem.Radius.s)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)

                        ProgressBarView(
                            label: "Calories",
                            value: viewModel.calories,
                            goal: viewModel.defaultGoal(for: .calories),
                            color: DesignSystem.Colors.move,
                            iconName: "flame.fill"
                        )
                        ProgressBarView(
                            label: "Exercise Minutes",
                            value: viewModel.exerciseMinutes,
                            goal: viewModel.defaultGoal(for: .exerciseMinutes),
                            color: DesignSystem.Colors.exercise,
                            iconName: "figure.run"
                        )
                        ProgressBarView(
                            label: "Stand Hours",
                            value: viewModel.standHours,
                            goal: viewModel.defaultGoal(for: .standHours),
                            color: DesignSystem.Colors.stand,
                            iconName: "clock"
                        )
                    }

                    if let competitive = viewModel.competitiveUser {
                        Divider()
                            .frame(height: 1)
                            .background(DesignSystem.Colors.secondary)
                            .padding(.vertical, DesignSystem.Spacing.m)

                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.m) {
                            Text("\(competitive.name) Progress")
                                .font(DesignSystem.Fonts.headline)
                                .foregroundColor(DesignSystem.Colors.primary)
                                .padding(.vertical, DesignSystem.Spacing.xs)
                                .padding(.horizontal, DesignSystem.Spacing.m)
                                .background(.ultraThinMaterial)
                                .cornerRadius(DesignSystem.Radius.s)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)

                            ProgressBarView(
                                label: "Calories",
                                value: competitive.currentProgress?.calories ?? 0,
                                goal: viewModel.defaultGoal(for: .calories),
                                color: DesignSystem.Colors.move.darker(),
                                iconName: "flame.fill"
                            )
                            ProgressBarView(
                                label: "Exercise Minutes",
                                value: competitive.currentProgress?.exerciseMinutes ?? 0,
                                goal: viewModel.defaultGoal(for: .exerciseMinutes),
                                color: DesignSystem.Colors.exercise.darker(),
                                iconName: "figure.run"
                            )
                            ProgressBarView(
                                label: "Stand Hours",
                                value: competitive.currentProgress?.standHours ?? 0,
                                goal: viewModel.defaultGoal(for: .standHours),
                                color: DesignSystem.Colors.stand.darker(),
                                iconName: "clock"
                            )
                        }
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
            await viewModel.checkResult(for: coordinator.currentUser?.id)
        }
        .onReceive(ticker) { _ in
            Task { await viewModel.checkResult(for: coordinator.currentUser?.id) }
        }
        .alert("Challenge ended", isPresented: Binding(
            get: { viewModel.popupMessage != nil },
            set: { newVal in if !newVal { viewModel.popupMessage = nil } }
        )) {
            Button("OK", role: .cancel) { viewModel.popupMessage = nil }
        } message: {
            Text(viewModel.popupMessage ?? "")
        }
    }
}

#Preview {
    MainView(coordinator: Coordinator())
}
