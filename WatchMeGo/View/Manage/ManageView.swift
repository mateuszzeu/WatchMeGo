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

    init(coordinator: Coordinator, user: AppUser) {
        self.coordinator = coordinator
        self.viewModel = ManageViewModel(currentUser: user)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.l) {
                VStack(spacing: DesignSystem.Spacing.xs) {
                    Text("Manage Friends & Invites")
                        .font(DesignSystem.Fonts.headline)
                        .foregroundColor(DesignSystem.Colors.primary)
                        .multilineTextAlignment(.center)
                    Text("Invite friends, review requests, and start competitions.")
                        .font(DesignSystem.Fonts.footnote)
                        .foregroundColor(DesignSystem.Colors.secondary)
                        .multilineTextAlignment(.center)
                }
                .cardStyle()

                VStack(spacing: DesignSystem.Spacing.m) {
                    Text("Invite a Friend")
                        .font(DesignSystem.Fonts.headline)
                        .foregroundColor(DesignSystem.Colors.primary)
                        .multilineTextAlignment(.center)

                    InviteField(text: $viewModel.usernameToInvite) {
                        viewModel.sendInviteTapped()
                    }
                }
                .cardStyle()

                FriendsSection(
                    friends: viewModel.friends,
                    isInCompetition: viewModel.isInCompetition(with:),
                    onSelect: { _ in }
                )
                .frame(minHeight: 120)
                .cardStyle()

                PendingInvitesSection(
                    pendingUsers: viewModel.pendingUsers,
                    onAccept: { viewModel.accept($0) },
                    onDecline: { viewModel.decline($0) }
                )
                .frame(minHeight: 76)
                .cardStyle()

                if viewModel.hasPendingCompetitionInvite,
                   let challenger = viewModel.pendingCompetitionChallengerName {
                    CompetitionCouponView(
                        challenger: challenger,
                        challenge: viewModel.couponChallenge,
                        onAccept: { Task { await viewModel.acceptCompetitionInvite() } },
                        onDecline: { Task { await viewModel.declineCompetitionInvite() } }
                    )
                }
            }
            .padding(DesignSystem.Spacing.l)
        }
        .background(DesignSystem.Colors.background)
        .hideKeyboardOnTap()
        .task { await viewModel.loadData() }
    }
}
