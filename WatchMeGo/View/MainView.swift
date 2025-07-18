//
//  MainView.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//

import SwiftUI

struct MainView: View {
    @Bindable var coordinator: Coordinator

    var body: some View {
        VStack {
            Text("Welcome, \(coordinator.currentUser?.name ?? "User")!")
                .font(.title)
                .padding()


            Button("Logout") {
                coordinator.logout()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainView(coordinator: Coordinator() )
}
