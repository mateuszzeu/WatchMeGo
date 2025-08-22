//
//  MainTabView.swift
//  WatchMeGo
//
//  Created by Liza on 21/07/2025.
//

import SwiftUI

struct MainTabView: View {
    @Bindable var coordinator: Coordinator
    let user: AppUser

    var body: some View {
        TabView {
            MainView(coordinator: coordinator)
                .tabItem { Label("Dashboard", systemImage: "chart.bar.fill") }

            ManageView(coordinator: coordinator, user: user)
                .tabItem { Label("Social", systemImage: "person.3.fill") }

            ChallengeView(coordinator: coordinator, user: user)
                .tabItem { Label("Competitions", systemImage: "trophy.fill") }

            SettingsView(coordinator: coordinator, user: user)
                .tabItem { Label("Profile", systemImage: "person.circle.fill") }
        }
        .tint(DesignSystem.Colors.accent)
        .overlay(InfoBannerView())
    }
}

