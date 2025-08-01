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

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        self.viewModel = ManageViewModel(currentUser: coordinator.currentUser!)
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
                                Image(systemName: viewModel.currentUser.activeCompetitionWith == user.name ? "flame.fill" : "flame")
                                    .foregroundColor(viewModel.currentUser.activeCompetitionWith == user.name ? .red : .gray)
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

            if viewModel.hasPendingCompetitionInvite, let challenger = viewModel.pendingCompetitionFrom {
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(challenger) invited you to a competition!")
                        .font(.headline)
                        .foregroundColor(.red)
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

            Spacer()
        }
        .padding()
        .task {
            await viewModel.loadData()
        }
        .alert(
            viewModel.currentUser.activeCompetitionWith == selectedFriend?.name
            ? "Do you want to stop the competition with \(selectedFriend?.name ?? "")?"
            : "Do you want to start a competition with \(selectedFriend?.name ?? "")?",
            isPresented: $showCompetitionAlert
        ) {
            Button("Yes", role: .destructive) {
                if let friend = selectedFriend {
                    Task {
                        if viewModel.currentUser.activeCompetitionWith == friend.name {
                            await viewModel.toggleCompetition(with: friend)
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

#Preview {
    ManageView(coordinator: Coordinator())
}
