//
//  AppRootView.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//

import SwiftUI

struct AppRootView: View {
    @Bindable private var coordinator = Coordinator()

    var body: some View {
        NavigationStack {
            Group {
                switch coordinator.screen {
                case .login:
                    LoginView(coordinator: coordinator)
                case .register:
                    RegisterView(coordinator: coordinator)
                case .main:
                    MainTabView(coordinator: coordinator)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
