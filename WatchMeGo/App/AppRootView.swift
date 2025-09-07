//
//  AppRootView.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//
import SwiftUI

struct AppRootView: View {
    @Bindable private var coordinator = Coordinator()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            switch coordinator.screen {
            case .splash:
                SplashView()
                    .task {
                        try? await Task.sleep(for: .seconds(1.6))
                        coordinator.navigate(to: .login)
                    }
            case .login:
                LoginView(coordinator: coordinator)
            case .register:
                RegisterView(coordinator: coordinator)
            case .main:
                MainContentView(coordinator: coordinator)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: coordinator.screen)
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

private struct MainContentView: View {
    @Bindable var coordinator: Coordinator
    
    var body: some View {
        if coordinator.currentUser != nil {
            MainTabView(coordinator: coordinator)
        } else {
            LoginView(coordinator: coordinator)
        }
    }
}
