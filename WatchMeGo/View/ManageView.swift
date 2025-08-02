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
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                TextField("Invite...", text: $viewModel.usernameToInvite)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .background(Color("BackgroundPrimary"))
                    .foregroundColor(Color("TextPrimary"))

                Button {
                    viewModel.sendInviteTapped()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color("ButtonPrimary"))
                        .clipShape(Circle())
                }
                .disabled(viewModel.usernameToInvite.isEmpty)
                .opacity(viewModel.usernameToInvite.isEmpty ? 0.5 : 1)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Friends")
                    .font(.headline)
                    .foregroundColor(Color("TextPrimary"))

                if viewModel.friends.isEmpty {
                    Text("No friends yet")
                        .foregroundColor(.gray)
                } else {
                    ForEach(viewModel.friends) { user in
                        HStack {
                            Text(user.name)
                            Spacer()
                            Button(action: {
                                selectedFriend = user
                                showCompetitionAlert = true
                            }) {
                                Image(systemName: viewModel.isInCompetition(with: user) ? "flame.fill" : "flame")
                                    .foregroundColor(viewModel.isInCompetition(with: user) ? .red : .gray)
                                    .font(.system(size: viewModel.isInCompetition(with: user) ? 28 : 22))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Pending Invites")
                    .font(.headline)
                    .foregroundColor(Color("TextPrimary"))

                if viewModel.pendingUsers.isEmpty {
                    Text("No pending invites")
                        .foregroundColor(.gray)
                } else {
                    ForEach(viewModel.pendingUsers) { user in
                        HStack(spacing: 5) {
                            Text(user.name)
                            Spacer()
                            Button("Accept") {
                                viewModel.accept(user)
                            }
                            .buttonStyle(.bordered)
                            .tint(.green)

                            Button("Decline") {
                                viewModel.decline(user)
                            }
                            .buttonStyle(.bordered)
                            .tint(.red)
                        }
                    }
                }
            }

            if viewModel.hasPendingCompetitionInvite, let challenger = viewModel.pendingCompetitionChallengerName {
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(challenger) invited you to a competition!")
                        .font(.headline)
                    HStack {
                        Button("Accept") {
                            Task { await viewModel.acceptCompetitionInvite() }
                        }
                        .buttonStyle(.bordered)
                        .tint(.green)
                        Button("Decline") {
                            Task { await viewModel.declineCompetitionInvite() }
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                    }
                }
                .padding(.top, 12)
            }
            
            Button {
                viewModel.logout(coordinator: coordinator)
            } label: {
                HStack {
                    Spacer()
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    Text("Log out")
                    Spacer()
                }
                .foregroundColor(.red)
                .font(.headline)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.vertical, 16)
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding()
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
                            .font(.callout)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.red.opacity(0.9))
                            .cornerRadius(20)
                            .shadow(radius: 8)
                            .padding(.bottom, 40)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    .animation(.easeInOut, value: ErrorHandler.shared.showError)
                }
            }
        )
    }
}
