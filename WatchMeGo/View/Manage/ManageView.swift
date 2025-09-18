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
                    Text("Invite friends by email, review requests, and start competitions.")
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

                    InviteField(text: $viewModel.emailToInvite) {
                        viewModel.sendInviteTapped()
                    }
                }
                .cardStyle()

                VStack(alignment: .leading, spacing: DesignSystem.Spacing.s) {
                    Text("Friends (\(viewModel.friends.count))")
                        .font(.headline)
                        .foregroundColor(DesignSystem.Colors.primary)
                    
                    if viewModel.friends.isEmpty {
                        VStack(spacing: DesignSystem.Spacing.s) {
                            Image(systemName: "person.2.slash")
                                .font(.largeTitle)
                                .foregroundColor(DesignSystem.Colors.secondary)
                            Text("No friends yet")
                                .font(.body)
                                .foregroundColor(DesignSystem.Colors.secondary)
                            Text("Invite someone and start your first competition.")
                                .font(.caption)
                                .foregroundColor(DesignSystem.Colors.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    } else {
                        ForEach(viewModel.friends) { friend in
                            HStack {
                                Circle()
                                    .fill(DesignSystem.Colors.accent.opacity(0.1))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Text(String(friend.name.prefix(1)))
                                            .font(.headline)
                                            .foregroundColor(DesignSystem.Colors.accent)
                                    )
                                
                                VStack(alignment: .leading) {
                                    Text(friend.name)
                                        .font(.body.weight(.medium))
                                        .foregroundColor(DesignSystem.Colors.primary)
                                    Text(friend.email)
                                        .font(.caption)
                                        .foregroundColor(DesignSystem.Colors.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, DesignSystem.Spacing.xs)
                        }
                    }
                }
                .frame(minHeight: 120)
                .cardStyle()

                VStack(alignment: .leading, spacing: DesignSystem.Spacing.s) {
                    Text("Pending Invites (\(viewModel.pendingInvites.count))")
                        .font(.headline)
                        .foregroundColor(DesignSystem.Colors.primary)
                    
                    if viewModel.pendingInvites.isEmpty {
                        VStack(spacing: DesignSystem.Spacing.s) {
                            Image(systemName: "envelope")
                                .font(.largeTitle)
                                .foregroundColor(DesignSystem.Colors.secondary)
                            Text("No pending invites")
                                .font(.body)
                                .foregroundColor(DesignSystem.Colors.secondary)
                            Text("When someone invites you, it will appear here.")
                                .font(.caption)
                                .foregroundColor(DesignSystem.Colors.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    } else {
                        ForEach(viewModel.pendingInvites) { friendship in
                            HStack {
                                Circle()
                                    .fill(DesignSystem.Colors.accent.opacity(0.1))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Text("?")
                                            .font(.headline)
                                            .foregroundColor(DesignSystem.Colors.accent)
                                    )
                                
                                VStack(alignment: .leading) {
                                    Text("Friend Request")
                                        .font(.body.weight(.medium))
                                        .foregroundColor(DesignSystem.Colors.primary)
                                    Text("From: \(friendship.requesterId)")
                                        .font(.caption)
                                        .foregroundColor(DesignSystem.Colors.secondary)
                                }
                                
                                Spacer()
                                
                                HStack(spacing: DesignSystem.Spacing.s) {
                                    Button("Accept") {
                                        viewModel.accept(friendship)
                                    }
                                    .font(.caption)
                                    .padding(.horizontal, DesignSystem.Spacing.s)
                                    .padding(.vertical, DesignSystem.Spacing.xs)
                                    .background(DesignSystem.Colors.accent)
                                    .foregroundColor(.white)
                                    .cornerRadius(DesignSystem.Radius.s)
                                    
                                    Button("Decline") {
                                        viewModel.decline(friendship)
                                    }
                                    .font(.caption)
                                    .padding(.horizontal, DesignSystem.Spacing.s)
                                    .padding(.vertical, DesignSystem.Spacing.xs)
                                    .background(DesignSystem.Colors.error)
                                    .foregroundColor(.white)
                                    .cornerRadius(DesignSystem.Radius.s)
                                }
                            }
                            .padding(.vertical, DesignSystem.Spacing.xs)
                        }
                    }
                }
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
