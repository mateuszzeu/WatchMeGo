//
//  HeaderView.swift
//  WatchMeGo
//
//  Created by MAT on 20/09/2025.
//
import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack {
            Text("Manage Friends & Invites")
                .font(.headline)
                .foregroundColor(DesignSystem.Colors.primary)
                .multilineTextAlignment(.center)
            Text("Invite friends, review requests, and start competitions.")
                .font(.footnote)
                .foregroundColor(DesignSystem.Colors.secondary)
                .multilineTextAlignment(.center)
        }
        .cardStyle()
    }
}
