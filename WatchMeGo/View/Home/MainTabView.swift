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
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                        .environment(\.symbolVariants, .fill)
                }

            ManageView(coordinator: coordinator, user: user)
                .tabItem {
                    Label("Social", systemImage: "person.3.fill")
                        .environment(\.symbolVariants, .fill)
                }

            ChallengeView(coordinator: coordinator, user: user)
                .tabItem {
                    Label("Competitions", systemImage: "trophy.fill")
                        .environment(\.symbolVariants, .fill)
                }

            SettingsView(coordinator: coordinator, user: user)
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                        .environment(\.symbolVariants, .fill)
                }
        }
        .tint(DesignSystem.Colors.accent)
//        .onAppear {
//            let appearance = UITabBarAppearance()
//            appearance.configureWithTransparentBackground()
//            appearance.backgroundColor = UIColor.clear
//            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
//            
//            appearance.shadowColor = UIColor.clear
//            appearance.shadowImage = UIImage()
//            
//            UITabBar.appearance().standardAppearance = appearance
//            UITabBar.appearance().scrollEdgeAppearance = appearance
//            
//            UITabBar.appearance().layer.cornerRadius = 20
//            UITabBar.appearance().layer.masksToBounds = true
//            UITabBar.appearance().shadowImage = UIImage()
//            UITabBar.appearance().backgroundImage = UIImage()
//        }

    }
}

