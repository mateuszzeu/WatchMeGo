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
                }
            ManageView(coordinator: coordinator)
                .tabItem {
                    Label("Friends", systemImage: "person.2.fill")
                }
        }
    }
}
