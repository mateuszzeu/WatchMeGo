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
    
    @State private var selectedDifficulty: Difficulty = .medium
    
    var body: some View {
        VStack {
            
            PickDifficultyView(selectedDifficulty: $selectedDifficulty)
            
            Spacer()
            
            if viewModel.isAuthorized {
                ProgressBarView(label: "Calories", value: viewModel.calories, goal: selectedDifficulty.caloriesGoal, color: .activityMove, iconName: "flame.fill")
                ProgressBarView(label: "Exercise Minutes", value: viewModel.exerciseMinutes, goal: selectedDifficulty.exerciseGoal, color: .activityExercise, iconName: "figure.run")
                ProgressBarView(label: "Stand Hours", value: viewModel.standHours, goal: selectedDifficulty.standGoal, color: .activityStand, iconName: "clock")
                
                Button("Refresh") {
                    viewModel.refreshAll()
                }
                .buttonStyle(.borderedProminent)
            } else {
                Text("HealthKit access required or denied.")
                    .foregroundColor(.red)
            }
            
            Spacer()
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

