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
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.s) {
            Text("Friends")
                .font(DesignSystem.Fonts.headline)
                .foregroundColor(DesignSystem.Colors.primary)
            if friends.isEmpty {
                Text("No friends yet")
                    .font(DesignSystem.Fonts.footnote)
                    .foregroundColor(DesignSystem.Colors.secondary)
            } else {
                LazyVStack(spacing: DesignSystem.Spacing.s) {
                    ForEach(friends) { user in
                        Button {
                            onSelect(user)
                        } label: {
                            HStack {
                                Text(user.name)
                                    .font(DesignSystem.Fonts.body)
                                    .foregroundColor(DesignSystem.Colors.primary)
                                Spacer()
                                Image(systemName: isInCompetition(user) ? "flame.fill" : "flame")
                                    .foregroundColor(isInCompetition(user) ? DesignSystem.Colors.error : DesignSystem.Colors.secondary)
                                    .font(.system(size: isInCompetition(user) ? 30 : 24))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, DesignSystem.Spacing.s)
                            .padding(.horizontal, DesignSystem.Spacing.m)
                            .background(.ultraThinMaterial)
                            .cornerRadius(DesignSystem.Radius.m)
                        }
                        .buttonStyle(.plain)
                        .contentShape(Rectangle())
                    }
                }
            }
        }
    }
}

#Preview {
    FriendsSection(friends: [], isInCompetition: { _ in false }, onSelect: { _ in })
        .padding()
        .background(DesignSystem.Colors.background)
}
