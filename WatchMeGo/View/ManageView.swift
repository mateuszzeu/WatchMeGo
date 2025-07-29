//
//  ManageView.swift
//  WatchMeGo
//
//  Created by Liza on 21/07/2025.
//

import SwiftUI

struct ManageView: View {
    @Bindable private var viewModel = ManageViewModel()
    @Bindable var coordinator: Coordinator

    var body: some View {
        VStack(spacing: 16) {

            VStack(spacing: 8) {
                HStack {
                    TextField("Enter username", text: $viewModel.usernameToInvite)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)

                    Button(action: {
                        viewModel.sendInviteTapped(coordinator: coordinator)
                    }) {
                        Text("Send")
                            .frame(width: 60)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.usernameToInvite.isEmpty)
                }

                if let inviteStatus = viewModel.inviteStatus {
                    Text(inviteStatus)
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            .padding(.horizontal)

            Divider().padding(.vertical, 8)

            if !viewModel.pendingUsers.isEmpty {
                Text("Pending Invites")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                List(viewModel.pendingUsers) { user in
                    HStack {
                        Text(user.name)
                        Spacer()

                        Button("Accept") {
                            viewModel.accept(user, coordinator: coordinator)
                        }
                        .buttonStyle(.bordered)
                        .tint(.green)

                        Button("Decline") {
                            viewModel.decline(user, coordinator: coordinator)
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                    }
                }
                .frame(height: 180)
                .listStyle(.plain)
            }

            if !viewModel.friends.isEmpty {
                Text("Friends")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                List(viewModel.friends) { user in
                    Text(user.name)
                }
                .listStyle(.plain)
            }

            Spacer()
        }
        .padding(.top, 40)
        .task {
            await viewModel.loadData(coordinator: coordinator)
        }
    }
}

#Preview {
    ManageView(coordinator: Coordinator())
}



