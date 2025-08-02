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
            if viewModel.isAuthorized {
                ProgressBarView(label: "Calories", value: viewModel.calories, goal: selectedDifficulty.caloriesGoal, color: Color("ActivityMove"), iconName: "flame.fill")
                ProgressBarView(label: "Exercise Minutes", value: viewModel.exerciseMinutes, goal: selectedDifficulty.exerciseGoal, color: Color("ActivityExercise"), iconName: "figure.run")
                ProgressBarView(label: "Stand Hours", value: viewModel.standHours, goal: selectedDifficulty.standGoal, color: Color("ActivityStand"), iconName: "clock")
            } else {
                Text("HealthKit access required or denied.")
                    .foregroundColor(Color("TextPrimary"))
            }
            
            Spacer()
        }
        .padding()
        .background(Color("BackgroundPrimary"))
        .task {
            await viewModel.loadDataAndSave(for: coordinator.currentUser?.id)
        }
    }
}

#Preview {
    MainView(coordinator: Coordinator())
}


