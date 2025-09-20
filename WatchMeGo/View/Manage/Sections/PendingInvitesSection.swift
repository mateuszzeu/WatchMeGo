//
//  PendingInvitesSection.swift
//  WatchMeGo
//
//  Created by MAT on 16/09/2025.
//
import SwiftUI

struct PendingInvitesSection: View {
    let pendingInvites: [Friendship]
    let requesterNames: [String: String]
    let onAccept: (Friendship) -> Void
    let onDecline: (Friendship) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.s) {
            Text("Pending Invites")
                .font(.headline)
                .foregroundColor(DesignSystem.Colors.primary)
            
            if pendingInvites.isEmpty {
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
                ForEach(pendingInvites) { friendship in
                    PendingInviteView(
                        friendship: friendship,
                        requesterName: requesterNames[friendship.requesterId] ?? friendship.requesterId,
                        onAccept: { onAccept(friendship) },
                        onDecline: { onDecline(friendship) }
                    )
                }
            }
        }
        .cardStyle()
    }
}
