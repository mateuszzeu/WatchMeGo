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
            VStack(spacing: DesignSystem.Spacing.l) {
                if let challenge = viewModel.activeChallenge {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.l) {
                        Text("Active Challenge")
                            .font(.headline)
                            .foregroundColor(DesignSystem.Colors.primary)
                        
                        VStack(spacing: DesignSystem.Spacing.m) {
                            Text(challenge.name)
                                .font(.body)
                                .foregroundColor(DesignSystem.Colors.primary)
                                .multilineTextAlignment(.center)
                            
                            if !challenge.metrics.isEmpty {
                                Text(challenge.metrics.map { $0.metric.title }.joined(separator: " • "))
                                    .font(.footnote)
                                    .foregroundColor(DesignSystem.Colors.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            
                            Text("Duration: \(challenge.duration) day\(challenge.duration > 1 ? "s" : "")")
                                .font(.footnote)
                                .foregroundColor(DesignSystem.Colors.secondary)
                                .multilineTextAlignment(.center)
                            
                            if let prize = challenge.prize, !prize.isEmpty {
                                Text("Prize: \(prize)")
                                    .font(.footnote)
                                    .foregroundColor(DesignSystem.Colors.secondary)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(DesignSystem.Spacing.s)
                        .background(DesignSystem.Colors.surface)
                        .cornerRadius(DesignSystem.Radius.l)
                        
                        PrimaryButton(title: "Abort Challenge") {
                            Task { await viewModel.abortActiveChallenge() }
                        }
                    }
                    .padding(DesignSystem.Spacing.m)
                    .background(DesignSystem.Colors.surface)
                    .cornerRadius(DesignSystem.Radius.l)
                    .shadow(radius: DesignSystem.Radius.s, y: DesignSystem.Spacing.xs)
                    
                } else {
                    VStack(spacing: DesignSystem.Spacing.m) {
                        Text("Create Challenge")
                            .font(.title2.bold())
                            .foregroundColor(DesignSystem.Colors.primary)
                            .padding(.bottom, DesignSystem.Spacing.s)
                        
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.m) {
                            VStack(spacing: DesignSystem.Spacing.s) {
                                Text("Select Friend")
                                    .font(.body.weight(.semibold))
                                    .foregroundColor(DesignSystem.Colors.primary)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: DesignSystem.Spacing.s) {
                                        ForEach(viewModel.friendUsernames, id: \.self) { friend in
                                            let isSelected = (viewModel.selectedFriendUsername == friend)
                                            Text(friend)
                                                .font(.callout.weight(isSelected ? .semibold : .regular))
                                                .padding(.vertical, 10)
                                                .padding(.horizontal, 14)
                                                .background(
                                                    Capsule()
                                                        .fill(isSelected ? DesignSystem.Colors.primary : DesignSystem.Colors.surface)
                                                )
                                                .overlay(
                                                    Capsule().stroke(DesignSystem.Colors.primary.opacity(isSelected ? 0 : 0.25), lineWidth: 1)
                                                )
                                                .foregroundColor(isSelected ? .white : DesignSystem.Colors.primary)
                                                .onTapGesture {
                                                    viewModel.selectedFriendUsername = friend
                                                }
                                        }
                                    }
                                    .padding(.horizontal, DesignSystem.Spacing.s)
                                }
                            }
                            .padding(DesignSystem.Spacing.s)
                            .background(DesignSystem.Colors.surface)
                            .cornerRadius(DesignSystem.Radius.m)
                            .onAppear {
                                if viewModel.selectedFriendUsername.isEmpty, let first = viewModel.friendUsernames.first {
                                    viewModel.selectedFriendUsername = first
                                }
                            }
                            
                            StyledTextField(title: "Challenge Name", text: $viewModel.challengeName)
                            
                            VStack(spacing: DesignSystem.Spacing.s) {
                                Text("Select Metrics")
                                    .font(.body.weight(.semibold))
                                    .foregroundColor(DesignSystem.Colors.primary)
                                
                                ForEach($viewModel.metricSelections) { $metric in
                                    Toggle(isOn: $metric.isSelected) {
                                        Text(metric.metric.title)
                                            .font(.callout)
                                    }
                                    .disabled(!metric.isSelected && viewModel.metricSelections.filter { $0.isSelected }.count >= 3)
                                }
                            }
                            .padding(DesignSystem.Spacing.s)
                            .background(DesignSystem.Colors.surface)
                            .cornerRadius(DesignSystem.Radius.m)
                            
                            VStack(spacing: DesignSystem.Spacing.s) {
                                Text("Challenge Duration")
                                    .font(.body.weight(.semibold))
                                    .foregroundColor(DesignSystem.Colors.primary)
                                
                                Stepper(value: $viewModel.challengeDurationDays, in: 1...7) {
                                    Text("\(viewModel.challengeDurationDays) day\(viewModel.challengeDurationDays > 1 ? "s" : "")")
                                        .foregroundColor(DesignSystem.Colors.secondary)
                                }
                            }
                            .padding(DesignSystem.Spacing.s)
                            .background(DesignSystem.Colors.surface)
                            .cornerRadius(DesignSystem.Radius.m)
                            
                            StyledTextField(title: "Prize (optional)", text: $viewModel.challengePrize)
                            
                            PrimaryButton(title: "Send Challenge") {
                                Task { await viewModel.sendChallenge() }
                            }
                            .disabled(!viewModel.isReadyToSend)
                        }
                    }
                    .padding(DesignSystem.Spacing.s)
                    .background(DesignSystem.Colors.surface)
                    .cornerRadius(DesignSystem.Radius.l)
                    .shadow(radius: DesignSystem.Radius.s, y: DesignSystem.Spacing.xs)
                }
            }
            .padding(DesignSystem.Spacing.l)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .hideKeyboardOnTap()
            .overlay(InfoBannerView())
            .task { await viewModel.refreshUser() }
        }
        .background(DesignSystem.Colors.background)
    }
}

#Preview {
    ChallengeView(
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
