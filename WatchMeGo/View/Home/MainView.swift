//
//  MainView.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//

import SwiftUI

struct MainView: View {
    @Bindable private var viewModel: MainViewModel
    @Bindable var coordinator: Coordinator
    
    @State private var now = Date()
    @State private var ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(coordinator: Coordinator, user: AppUser) {
        self.coordinator = coordinator
        self.viewModel = MainViewModel(currentUser: user)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.l) {
                if viewModel.isAuthorized {
                    if let challenge = viewModel.activeChallenge {
                        VStack(spacing: DesignSystem.Spacing.s) {
                            Text("Time left")
                                .font(DesignSystem.Fonts.footnote)
                                .foregroundColor(DesignSystem.Colors.secondary)
                            HStack(spacing: DesignSystem.Spacing.s) {
                                Image(systemName: "timer")
                                    .foregroundColor(DesignSystem.Colors.accent)
                                Text(viewModel.remainingString(from: challenge.createdAt, days: challenge.duration, now: now))
                                    .font(DesignSystem.Fonts.headline)
                                    .foregroundColor(DesignSystem.Colors.primary)
                            }
                        }
                        .cardStyle()
                        .onReceive(ticker) { currentTime in
                            now = currentTime
                            Task { await viewModel.handleTick(now: currentTime) }
                        }
                    }
                    
                    if viewModel.hasPendingCompetitionInvite,
                       let challenger = viewModel.pendingCompetitionChallengerName {
                        CompetitionCouponView(
                            challenger: challenger,
                            challenge: viewModel.couponChallenge,
                            onAccept: { Task { await viewModel.acceptCompetitionInvite() } },
                            onDecline: { Task { await viewModel.declineCompetitionInvite() } }
                        )
                    }
                    
                    VStack(spacing: DesignSystem.Spacing.s) {
                        Text("\(coordinator.currentUser?.name ?? "You") - today")
                            .font(DesignSystem.Fonts.headline)
                            .foregroundColor(DesignSystem.Colors.primary)
                            .multilineTextAlignment(.center)
                        
                        VStack(spacing: DesignSystem.Spacing.m) {
                            ForEach(viewModel.displayedMetrics) { metric in
                                ProgressBarView(
                                    label: metric.title,
                                    value: viewModel.value(for: metric, of: nil),
                                    goal: {
                                        if viewModel.activeChallenge != nil {
                                            return viewModel.challengeGoal(for: metric)
                                        } else {
                                            return viewModel.defaultGoal(for: metric)
                                        }
                                    }(),
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
                    }
                    .cardStyle()
                    
                    if let rival = viewModel.competitiveUser {
                        VStack(spacing: DesignSystem.Spacing.s) {
                            Text("\(rival.name) - today")
                                .font(DesignSystem.Fonts.headline)
                                .foregroundColor(DesignSystem.Colors.primary)
                                .multilineTextAlignment(.center)
                            
                            VStack(spacing: DesignSystem.Spacing.m) {
                                ForEach(viewModel.displayedMetrics) { metric in
                                    ProgressBarView(
                                        label: metric.title,
                                        value: viewModel.value(for: metric, of: rival),
                                        goal: {
                                            if viewModel.activeChallenge != nil {
                                                return viewModel.challengeGoal(for: metric)
                                            } else {
                                                return viewModel.defaultGoal(for: metric)
                                            }
                                        }(),
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
                        .cardStyle()
                    }
                    
                } else {
                    Text("HealthKit access required or denied.")
                        .font(DesignSystem.Fonts.body)
                        .foregroundColor(DesignSystem.Colors.primary)
                        .cardStyle()
                }
            }
            .padding(DesignSystem.Spacing.l)
        }
        .background(DesignSystem.Colors.background)
        .task {
            guard coordinator.currentUser != nil else { return }
            await viewModel.loadDataAndSave()
            await viewModel.checkResult(for: coordinator.currentUser?.id)
        }
        .alert(item: $viewModel.popupMessage) { item in
            Alert(
                title: Text("Challenge ended"),
                message: Text(item.text),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    MainView(
        coordinator: Coordinator(),
        user: AppUser(
            id: "1",
            name: "Alice",
            createdAt: Date(),
            friends: ["Bob", "Carol", "Dave"],
            pendingInvites: [],
            sentInvites: [],
            currentProgress: nil,
            history: [:],
            activeCompetitionWith: nil,
            pendingCompetitionWith: nil
        )
    )
}
