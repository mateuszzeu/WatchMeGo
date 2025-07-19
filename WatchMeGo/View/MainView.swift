//
//  MainView.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//

import SwiftUI

struct MainView: View {
    @Bindable private var viewModel = MainViewModel()
    @Bindable var coordinator: Coordinator

    var body: some View {
        VStack(spacing: 16) {
            if viewModel.isAuthorized {
                Text("Calories burned today: \(viewModel.calories)")
                    .font(.title)
                Text("Exercise minutes today: \(viewModel.exerciseMinutes)")
                    .font(.title2)
                Text("Stand hours today: \(viewModel.standHours)")
                    .font(.title2)
                Button("Refresh") {
                    viewModel.refreshAll()
                }
                .buttonStyle(.borderedProminent)
            } else {
                Text("HealthKit access required or denied.")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .onAppear {
            viewModel.requestHealthKitAccessAndFetchAll()
        }
    }
}

#Preview {
    MainView(coordinator: Coordinator())
}

