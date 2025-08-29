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
                            VStack(spacing: DesignSystem.Spacing.xs) {
                                Text("Active Challenge")
                                    .font(.headline)
                                    .foregroundColor(DesignSystem.Colors.primary)
                                Text(challenge.name)
                                    .font(.subheadline)
                                    .foregroundColor(DesignSystem.Colors.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            
                            VStack(spacing: DesignSystem.Spacing.xs) {
                                Text("Time left")
                                    .font(.caption)
                                    .foregroundColor(DesignSystem.Colors.secondary)
                                Text(viewModel.remainingString(from: challenge.createdAt, days: challenge.duration, now: now))
                                    .font(.title2.bold())
                                    .foregroundColor(DesignSystem.Colors.accent)
                                    .monospacedDigit()
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(DesignSystem.Spacing.l)
                        .background(
                            RoundedRectangle(cornerRadius: DesignSystem.Radius.l)
                                .fill(DesignSystem.Colors.surface)
                                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                        )
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
                    
                    VStack(spacing: DesignSystem.Spacing.m) {
                        Text("Today's Progress")
                            .font(.title2.bold())
                            .foregroundColor(DesignSystem.Colors.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
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
                    .padding(DesignSystem.Spacing.l)
                    .background(
                        RoundedRectangle(cornerRadius: DesignSystem.Radius.l)
                            .fill(DesignSystem.Colors.surface)
                            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                    )
                    
                    if let rival = viewModel.competitiveUser {
                        VStack(spacing: DesignSystem.Spacing.m) {
                            HStack(spacing: DesignSystem.Spacing.m) {
                                Circle()
                                    .fill(DesignSystem.Colors.accent.opacity(0.1))
                                    .frame(width: 48, height: 48)
                                    .overlay(
                                        Text(String(rival.name.prefix(1)))
                                            .font(.title3.bold())
                                            .foregroundColor(DesignSystem.Colors.accent)
                                    )
                                
                                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xs) {
                                    Text(rival.name)
                                        .font(.headline)
                                        .foregroundColor(DesignSystem.Colors.primary)
                                    Text("Your competitor")
                                        .font(.caption)
                                        .foregroundColor(DesignSystem.Colors.secondary)
                                }
                                
                                Spacer()
                            }
                            
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
                        .padding(DesignSystem.Spacing.l)
                        .background(
                            RoundedRectangle(cornerRadius: DesignSystem.Radius.l)
                                .fill(DesignSystem.Colors.surface)
                                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                        )
                    }
                    
                } else {
                    VStack(spacing: DesignSystem.Spacing.m) {
                        Image(systemName: "heart.slash")
                            .font(.largeTitle)
                            .foregroundColor(DesignSystem.Colors.error)
                        
                        Text("HealthKit access required or denied.")
                            .font(DesignSystem.Fonts.body)
                            .foregroundColor(DesignSystem.Colors.primary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(DesignSystem.Spacing.l)
                    .background(DesignSystem.Colors.surface)
                    .cornerRadius(DesignSystem.Radius.l)
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
            email: "mail@example.com",
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
