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
        VStack {
            if viewModel.isAuthorized {
                ProgressBarView(label: "Calories", value: viewModel.calories, goal: 500, color: Color("ActivityMove"), iconName: "flame.fill")
                ProgressBarView(label: "Exercise Minutes", value: viewModel.exerciseMinutes, goal: 80, color: Color("ActivityExercise"), iconName: "figure.run")
                ProgressBarView(label: "Stand Hours", value: viewModel.standHours, goal: 10, color: Color("ActivityStand"), iconName: "clock")
                
                if let competitive = viewModel.competitiveUser {
                    ProgressBarView(label: "\(competitive.name)'s Calories", value: competitive.currentProgress?.calories ?? 0, goal: 500, color: Color("ActivityMove"), iconName: "flame.fill")
                    ProgressBarView(label: "\(competitive.name)'s Exercise Minutes", value: competitive.currentProgress?.exerciseMinutes ?? 0, goal: 80, color: Color("ActivityExercise"), iconName: "figure.run")
                    ProgressBarView(label: "\(competitive.name)'s Stand Hours", value: competitive.currentProgress?.standHours ?? 0, goal: 10, color: Color("ActivityStand"), iconName: "clock")
                }
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


