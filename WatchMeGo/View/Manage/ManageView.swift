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

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        self.viewModel = ManageViewModel(coordinator: coordinator)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.l) {
                VStack {
                    Text("Manage Friends & Invites")
                        .font(.headline)
                        .foregroundColor(DesignSystem.Colors.primary)
                        .multilineTextAlignment(.center)
                    Text("Invite friends, review requests, and start competitions.")
                        .font(.footnote)
                        .foregroundColor(DesignSystem.Colors.secondary)
                        .multilineTextAlignment(.center)
                }
                .cardStyle()

                VStack {
                    Text("Invite a Friend")
                        .font(.headline)
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
            }
            .padding(DesignSystem.Spacing.l)
        }
        .background(DesignSystem.Colors.background)
        .hideKeyboardOnTap()
        .overlay(InfoBannerView())
        .task { await viewModel.loadData() }
    }
}
