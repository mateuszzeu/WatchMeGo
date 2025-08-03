//
//  ManageView.swift
//  WatchMeGo
//
//  Created by Liza on 21/07/2025.
//

import SwiftUI

struct ManageView: View {
    @Bindable var coordinator: Coordinator
    @Bindable private var viewModel: ManageViewModel

    @State private var selectedFriend: AppUser?
    @State private var showCompetitionAlert = false

    init(coordinator: Coordinator, user: AppUser) {
        self.coordinator = coordinator
        self.viewModel = ManageViewModel(currentUser: user)
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: DesignSystem.Spacing.l) {
                ChallengeBannerView(username: viewModel.currentUser.name)

                HStack(spacing: DesignSystem.Spacing.s) {
                    StyledTextField(title: "Invite...", text: $viewModel.usernameToInvite)
                    Button { viewModel.sendInviteTapped() } label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(DesignSystem.Colors.background)
                            .padding(DesignSystem.Spacing.s)
                            .background(DesignSystem.Colors.accent)
                            .clipShape(Circle())
                    }
                    .disabled(viewModel.usernameToInvite.isEmpty)
                    .opacity(viewModel.usernameToInvite.isEmpty ? 0.5 : 1)
                }

                Divider()

                FriendsSection(
                    friends: viewModel.friends,
                    isInCompetition: viewModel.isInCompetition(with:),
                    onSelect: { user in
                        selectedFriend = user
                        showCompetitionAlert = true
                    }
                )

                Divider()

                PendingInvitesSection(
                    pendingUsers: viewModel.pendingUsers,
                    onAccept: { viewModel.accept($0) },
                    onDecline: { viewModel.decline($0) }
                )

                if viewModel.hasPendingCompetitionInvite,
                   let challenger = viewModel.pendingCompetitionChallengerName {
                    CompetitionCouponView(
                        challenger: challenger,
                        onAccept: { Task { await viewModel.acceptCompetitionInvite() } },
                        onDecline: { Task { await viewModel.declineCompetitionInvite() } }
                    )
                }
            }
            .padding(DesignSystem.Spacing.l)
        }
        .background(DesignSystem.Colors.background.ignoresSafeArea())
        .safeAreaInset(edge: .bottom) {
            PrimaryButton(title: "Log out") {
                viewModel.logout(coordinator: coordinator)
            }
            .padding(.horizontal, DesignSystem.Spacing.l)
            .padding(.vertical, DesignSystem.Spacing.s)
            .padding(.bottom, DesignSystem.Spacing.m)
            .background(DesignSystem.Colors.background)
        }
        .task { await viewModel.loadData() }
        .alert(
            (selectedFriend != nil && viewModel.isInCompetition(with: selectedFriend!))
            ? "Do you want to stop the competition with \(selectedFriend?.name ?? "")?"
            : "Do you want to start a competition with \(selectedFriend?.name ?? "")?",
            isPresented: $showCompetitionAlert
        ) {
            Button("Yes", role: .destructive) {
                if let friend = selectedFriend {
                    Task {
                        if viewModel.isInCompetition(with: friend) {
                            viewModel.endCompetition(with: friend)
                        } else {
                            await viewModel.inviteToCompetition(friend: friend)
                        }
                    }
                }
            }
            Button("No", role: .cancel) { }
        }
    }
}
