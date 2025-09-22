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
                    Label("Home", systemImage: "house.fill")
                        .environment(\.symbolVariants, .fill)
                }
            
            ManageView(coordinator: coordinator)
                .tabItem {
                    Label("Friends", systemImage: "person.2.fill")
                        .environment(\.symbolVariants, .fill)
                }
            
            CompetitionView(coordinator: coordinator)
                .tabItem {
                    Label("Challenge", systemImage: "flame.fill")
                        .environment(\.symbolVariants, .fill)
                }
            
            SettingsView(coordinator: coordinator)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
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

