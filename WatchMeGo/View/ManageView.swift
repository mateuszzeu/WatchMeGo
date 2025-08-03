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
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.l) {
            HStack(spacing: DesignSystem.Spacing.s) {
                StyledTextField(title: "Invite...", text: $viewModel.usernameToInvite)

                Button {
                    viewModel.sendInviteTapped()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(DesignSystem.Colors.background)
                        .padding(DesignSystem.Spacing.s)
                        .background(DesignSystem.Colors.accent)
                        .clipShape(Circle())
                }
                .disabled(viewModel.usernameToInvite.isEmpty)
                .opacity(viewModel.usernameToInvite.isEmpty ? 0.5 : 1)
            }

            VStack(alignment: .leading, spacing: DesignSystem.Spacing.s) {
                Text("Friends")
                    .font(DesignSystem.Fonts.headline)
                    .foregroundColor(DesignSystem.Colors.primary)

                if viewModel.friends.isEmpty {
                    Text("No friends yet")
                        .font(DesignSystem.Fonts.footnote)
                        .foregroundColor(DesignSystem.Colors.secondary)
                } else {
                    ForEach(viewModel.friends) { user in
                        HStack {
                            Text(user.name)
                                .font(DesignSystem.Fonts.body)
                            Spacer()
                            Button(action: {
                                selectedFriend = user
                                showCompetitionAlert = true
                            }) {
                                Image(systemName: viewModel.isInCompetition(with: user) ? "flame.fill" : "flame")
                                    .foregroundColor(viewModel.isInCompetition(with: user) ? DesignSystem.Colors.error : DesignSystem.Colors.secondary)
                                    .font(.system(size: viewModel.isInCompetition(with: user) ? 30 : 24))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: DesignSystem.Spacing.s) {
                Text("Pending Invites")
                    .font(DesignSystem.Fonts.headline)
                    .foregroundColor(DesignSystem.Colors.primary)

                if viewModel.pendingUsers.isEmpty {
                    Text("No pending invites")
                        .font(DesignSystem.Fonts.footnote)
                        .foregroundColor(DesignSystem.Colors.secondary)
                } else {
                    ForEach(viewModel.pendingUsers) { user in
                        HStack(spacing: DesignSystem.Spacing.s) {
                            Text(user.name)
                                .font(DesignSystem.Fonts.body)
                            Spacer()
                            Button("Accept") {
                                viewModel.accept(user)
                            }
                            .buttonStyle(.bordered)
                            .tint(DesignSystem.Colors.accent)

                            Button("Decline") {
                                viewModel.decline(user)
                            }
                            .buttonStyle(.bordered)
                            .tint(DesignSystem.Colors.error)
                        }
                    }
                }
            }

            if viewModel.hasPendingCompetitionInvite, let challenger = viewModel.pendingCompetitionChallengerName {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.s) {
                    Text("\(challenger) invited you to a competition!")
                        .font(DesignSystem.Fonts.headline)
                    HStack(spacing: DesignSystem.Spacing.s) {
                        Button("Accept") {
                            Task { await viewModel.acceptCompetitionInvite() }
                        }
                        .buttonStyle(.bordered)
                        .tint(DesignSystem.Colors.accent)
                        Button("Decline") {
                            Task { await viewModel.declineCompetitionInvite() }
                        }
                        .buttonStyle(.bordered)
                        .tint(DesignSystem.Colors.error)
                    }
                }
                .padding(.top, DesignSystem.Spacing.m)
            }

            Spacer()

            PrimaryButton(title: "Log out", color: DesignSystem.Colors.error) {
                viewModel.logout(coordinator: coordinator)
            }
            .padding(.vertical, DesignSystem.Spacing.m)
        }
        .padding(DesignSystem.Spacing.l)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(DesignSystem.Colors.background)
        .ignoresSafeArea()
        .task {
            await viewModel.loadData()
        }
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
        .overlay(
            Group {
                if ErrorHandler.shared.showError, let msg = ErrorHandler.shared.errorMessage {
                    VStack {
                        Spacer()
                        Text(msg)
                            .font(DesignSystem.Fonts.footnote)
                            .foregroundColor(DesignSystem.Colors.background)
                            .padding(.horizontal, DesignSystem.Spacing.l)
                            .padding(.vertical, DesignSystem.Spacing.s)
                            .background(DesignSystem.Colors.error.opacity(0.9))
                            .cornerRadius(DesignSystem.Radius.l)
                            .shadow(radius: DesignSystem.Radius.s)
                            .padding(.bottom, DesignSystem.Spacing.l * 2)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    .animation(.easeInOut, value: ErrorHandler.shared.showError)
                }
            }
        )
    }
}
