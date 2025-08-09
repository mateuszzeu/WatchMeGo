//
//  ChallengeView.swift
//  WatchMeGo
//
//  Created by Liza on 06/08/2025.
//

import SwiftUI

struct ChallengeView: View {
    @Bindable var coordinator: Coordinator
    @Bindable private var viewModel: ChallengeViewModel

    init(coordinator: Coordinator, user: AppUser) {
        self.coordinator = coordinator
        self.viewModel = ChallengeViewModel(loggedInUser: user)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.m) {

                if let challenge = viewModel.activeChallenge {
                    Text("Active challenge")
                        .font(DesignSystem.Fonts.headline)
                        .foregroundColor(DesignSystem.Colors.primary)

                    VStack(spacing: DesignSystem.Spacing.s) {
                        Text(challenge.name)
                            .font(DesignSystem.Fonts.body)
                            .foregroundColor(DesignSystem.Colors.primary)
                            .multilineTextAlignment(.center)

                        if !challenge.metrics.isEmpty {
                            Text(challenge.metrics.map { $0.metric.title }.joined(separator: " • "))
                                .font(DesignSystem.Fonts.footnote)
                                .foregroundColor(DesignSystem.Colors.secondary)
                                .multilineTextAlignment(.center)
                        }

                        Text("Duration: \(challenge.duration) day\(challenge.duration > 1 ? "s" : "")")
                            .font(DesignSystem.Fonts.footnote)
                            .foregroundColor(DesignSystem.Colors.secondary)
                            .multilineTextAlignment(.center)

                        if let prize = challenge.prize, !prize.isEmpty {
                            Text("Prize: \(prize)")
                                .font(DesignSystem.Fonts.footnote)
                                .foregroundColor(DesignSystem.Colors.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(DesignSystem.Radius.m)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.Radius.m)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )

                    PrimaryButton(title: "Abort challenge") {
                        viewModel.abortActiveChallenge()
                    }

                } else {

                    Menu {
                        ForEach(viewModel.friendUsernames, id: \.self) { friend in
                            Button(friend) { viewModel.selectedFriendUsername = friend }
                        }
                    } label: {
                        HStack {
                            Text(viewModel.selectedFriendUsername.isEmpty ? "Select Friend" : viewModel.selectedFriendUsername)
                                .foregroundColor(DesignSystem.Colors.primary)
                            Spacer(minLength: 0)
                        }
                        .padding(.vertical, DesignSystem.Spacing.xs)
                        .padding(.horizontal, DesignSystem.Spacing.m)
                        .background(.ultraThinMaterial)
                        .cornerRadius(DesignSystem.Radius.s)
                    }

                    StyledTextField(title: "Challenge Name", text: $viewModel.challengeName)

                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.s) {
                        ForEach($viewModel.metricSelections) { $metric in
                            Toggle(metric.metric.title, isOn: $metric.isSelected)
                                .disabled(!metric.isSelected && viewModel.metricSelections.filter { $0.isSelected }.count >= 3)
                        }
                    }
                    .padding(.vertical, DesignSystem.Spacing.s)

                    Stepper(value: $viewModel.challengeDurationDays, in: 1...7) {
                        Text("Duration: \(viewModel.challengeDurationDays) day\(viewModel.challengeDurationDays > 1 ? "s" : "")")
                    }

                    StyledTextField(title: "Prize / Forfeit (optional)", text: $viewModel.challengePrize)

                    PrimaryButton(title: "Send Challenge") {
                        viewModel.sendChallenge()
                    }
                    .disabled(!viewModel.isReadyToSend)
                    .opacity(viewModel.isReadyToSend ? 1 : 0.5)
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.l)
            .padding(.vertical, DesignSystem.Spacing.l)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .task { await viewModel.refreshUser() }
        .background(DesignSystem.Colors.background.ignoresSafeArea())
    }
}

#Preview {
    ChallengeView(
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
            pendingCompetitionWith: nil,
            competitionStatus: "none"
        )
    )
}
