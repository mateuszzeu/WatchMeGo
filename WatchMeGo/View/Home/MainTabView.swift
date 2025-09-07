//
//  MainTabView.swift
//  WatchMeGo
//
//  Created by Liza on 21/07/2025.
//

import SwiftUI

struct MainTabView: View {
    @Bindable var coordinator: Coordinator
    
    var body: some View {
        TabView {
            MainView(coordinator: coordinator)
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                        .environment(\.symbolVariants, .fill)
                }
            
            ManageView(coordinator: coordinator)
                .tabItem {
                    Label("Social", systemImage: "person.3.fill")
                        .environment(\.symbolVariants, .fill)
                }
            
            ChallengeView(coordinator: coordinator)
                .tabItem {
                    Label("Competitions", systemImage: "trophy.fill")
                        .environment(\.symbolVariants, .fill)
                }
            
            SettingsView(coordinator: coordinator)
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                        .environment(\.symbolVariants, .fill)
                }
        }
        .tint(DesignSystem.Colors.accent)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            UITabBar.appearance().layer.cornerRadius = 20
            UITabBar.appearance().layer.masksToBounds = true
        }
    }
}

