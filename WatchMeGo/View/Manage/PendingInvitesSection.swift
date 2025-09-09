//
//  PendingInvitesSection.swift
//  WatchMeGo
//
//  Created by Liza on 03/08/2025.
//

import SwiftUI

struct PendingInvitesSection: View {
    let pendingUsers: [AppUser]
    let onAccept: (AppUser) -> Void
    let onDecline: (AppUser) -> Void

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.s) {
            Text("Pending Invites")
                .font(.headline)
                .foregroundColor(DesignSystem.Colors.primary)

            if pendingUsers.isEmpty {
                PlaceholderCardContent(
                    systemImage: "envelope.badge",
                    title: "No pending invites",
                    subtitle: "When someone invites you, it will appear here."
                )
            } else {
                LazyVStack(spacing: DesignSystem.Spacing.xs) {
                    ForEach(pendingUsers) { user in
                        HStack {
                            Text(user.name)
                                .font(.body)
                                .foregroundColor(DesignSystem.Colors.primary)
                            Spacer()
                            Button("Accept") { onAccept(user) }
                                .buttonStyle(.borderedProminent)
                                .tint(DesignSystem.Colors.accent)
                                .controlSize(.small)
                            Button("Decline") { onDecline(user) }
                                .buttonStyle(.bordered)
                                .tint(DesignSystem.Colors.error)
                                .controlSize(.small)
                        }
                        .padding(DesignSystem.Spacing.m)
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignSystem.Radius.m)
                                .stroke(DesignSystem.Colors.background, lineWidth: 3)
                        )
                        .cornerRadius(DesignSystem.Radius.m)
                    }
                }
            }
        }
    }
}



#Preview {
    PendingInvitesSection(pendingUsers: [], onAccept: { _ in }, onDecline: { _ in })
        .padding()
        .background(DesignSystem.Colors.background)
}
