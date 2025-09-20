//
//  FriendsSection.swift
//  WatchMeGo
//
//  Created by MAT on 20/09/2025.
//
import SwiftUI

struct FriendsSection: View {
    let friends: [AppUser]
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.s) {
            Text("Friends")
                .font(.headline)
                .foregroundColor(DesignSystem.Colors.primary)
            
            if friends.isEmpty {
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
                ForEach(friends) { friend in
                    FriendView(
                        name: friend.name,
                        showFlameIcon: true,
                        flameIconFilled: false
                    )
                }
            }
        }
        .cardStyle()
    }
}
