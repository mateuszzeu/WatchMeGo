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
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        self.viewModel = MainViewModel(coordinator: coordinator)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.l) {
                if viewModel.isAuthorized {
                    BadgeRowView(badgeCounts: viewModel.badgeCounts)
                    
                    if let competition = viewModel.activeCompetition {
                        ActiveCompetitionView(
                            competition: competition,
                            competitiveUser: viewModel.competitiveUser,
                            remainingString: viewModel.remainingString(from: competition.startDate, days: competition.duration, now: now),
                            onTick: { currentTime in
                                now = currentTime
                                Task { await viewModel.handleTick(now: currentTime) }
                            }
                        )
                    }
                    
                    if viewModel.hasPendingCompetitionInvite,
                       let competitor = viewModel.pendingCompetitionChallengerName {
                        CompetitionCouponView(
                            competitor: competitor,
                            competition: viewModel.couponCompetition,
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
                                    goal: viewModel.defaultGoal(for: metric),
                                    color: {
                                        switch metric {
                                        case .calories: return DesignSystem.Colors.move
                                        case .exerciseMinutes: return DesignSystem.Colors.exercise
                                        case .standHours: return DesignSystem.Colors.stand
                                        }
                                    }(),
                                    iconName: metric.iconName,
                                )
                            }
                        }
                    }
                    .cardStyle()
                    
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
                                        goal: viewModel.defaultGoal(for: metric),
                                        color: {
                                            switch metric {
                                            case .calories: return DesignSystem.Colors.move
                                            case .exerciseMinutes: return DesignSystem.Colors.exercise
                                            case .standHours: return DesignSystem.Colors.stand
                                            }
                                        }(),
                                        iconName: metric.iconName,
                                    )
                                }
                            }
                        }
                        .cardStyle()
                    }
                    
                } else {
                    VStack(spacing: DesignSystem.Spacing.m) {
                        Image(systemName: "heart.slash")
                            .font(.largeTitle)
                            .foregroundColor(DesignSystem.Colors.error)
                        
                        Text("HealthKit access required or denied.")
                            .font(.body)
                            .foregroundColor(DesignSystem.Colors.primary)
                    }
                    .cardStyle()
                }
            }
            .padding(DesignSystem.Spacing.l)
        }
        .background(DesignSystem.Colors.background)
        .overlay(InfoBannerView())
        .task {
            guard coordinator.currentUser != nil else { return }
            await viewModel.loadDataAndSave()
            await viewModel.checkResult(for: coordinator.currentUser?.id)
        }
        .alert(item: $viewModel.popupMessage) { item in
            Alert(
                title: Text("Competition ended"),
                message: Text(item.text),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    MainView(coordinator: Coordinator())
}
