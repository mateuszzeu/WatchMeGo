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
                .tabItem { Label("Home", systemImage: "house.fill") }

            ManageView(coordinator: coordinator, user: user)
                .tabItem { Label("Friends", systemImage: "person.2.fill") }

            ChallengeView(coordinator: coordinator, user: user)
                .tabItem { Label("Challenge", systemImage: "flag.checkered") }

            SettingsView(coordinator: coordinator, user: user)
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
        .tint(DesignSystem.Colors.accent)
        .overlay(ErrorBannerView())
    }
}

