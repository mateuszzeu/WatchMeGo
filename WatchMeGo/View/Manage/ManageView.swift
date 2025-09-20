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
                HeaderView()
                
                InviteSection(
                    emailToInvite: $viewModel.emailToInvite,
                    onSendInvite: { viewModel.sendInviteTapped() }
                )
                
                FriendsSection(friends: viewModel.friends)
                
                PendingInvitesSection(
                    pendingInvites: viewModel.pendingInvites,
                    requesterNames: viewModel.requesterNames,
                    onAccept: { viewModel.accept($0) },
                    onDecline: { viewModel.decline($0) }
                )
            }
            .padding(DesignSystem.Spacing.l)
        }
        .background(DesignSystem.Colors.background)
        .hideKeyboardOnTap()
        .overlay(InfoBannerView())
        .task { await viewModel.loadData() }
    }
}
