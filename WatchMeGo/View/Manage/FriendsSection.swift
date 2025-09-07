//
//  FriendsSection.swift
//  WatchMeGo
//
//  Created by Liza on 03/08/2025.
//

import SwiftUI

struct FriendsSection: View {
    let friends: [AppUser]
    let isInCompetition: (AppUser) -> Bool
    let onSelect: (AppUser) -> Void

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.s) {
            Text("Friends")
                .font(.headline)
                .foregroundColor(DesignSystem.Colors.primary)

            if friends.isEmpty {
                PlaceholderCardContent(
                    systemImage: "person.2.slash",
                    title: "No friends yet",
                    subtitle: "Invite someone and start your first competition."
                )
            } else {
                LazyVStack {
                    ForEach(friends) { user in
                        Button {
                            onSelect(user)
                        } label: {
                            HStack(spacing: DesignSystem.Spacing.s) {
                                Circle()
                                    .fill(DesignSystem.Colors.accent.opacity(0.18))
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Text(String(user.name.prefix(1)))
                                            .font(.callout.weight(.bold))
                                            .foregroundColor(DesignSystem.Colors.accent)
                                    )

                                Text(user.name)
                                    .font(.body)
                                    .foregroundColor(DesignSystem.Colors.primary)

                                Spacer()

                                Image(systemName: isInCompetition(user) ? "flame.fill" : "flame")
                                    .foregroundColor(isInCompetition(user) ? DesignSystem.Colors.error : DesignSystem.Colors.secondary)
                                    .font(.system(size: 26))
                            }
                            .padding(DesignSystem.Spacing.s)
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial)
                            .cornerRadius(DesignSystem.Radius.m)
                        }
                        .buttonStyle(.plain)
                        .contentShape(Rectangle())
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}



#Preview {
    FriendsSection(friends: [], isInCompetition: { _ in false }, onSelect: { _ in })
        .padding()
        .background(DesignSystem.Colors.background)
}
