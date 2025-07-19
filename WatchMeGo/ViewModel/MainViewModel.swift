//
//  MainViewModel.swift
//  WatchMeGo
//
//  Created by Liza on 19/07/2025.
//
import Foundation

@Observable
final class MainViewModel {
    var isAuthorized = false

    var calories = 0
    var exerciseMinutes = 0
    var standHours = 0

    func loadDataAndSave(for userID: String?) async {
        isAuthorized = await HealthKitService.shared.requestAuthorization()
        guard isAuthorized else { return }

        async let calories = HealthKitService.shared.fetchTodayBurnedCalories()
        async let minutes = HealthKitService.shared.fetchTodayExerciseMinutes()
        async let hours = HealthKitService.shared.fetchTodayStandHours()

        self.calories = await calories
        self.exerciseMinutes = await minutes
        self.standHours = await hours

        saveProgress(for: userID)
    }

    func saveProgress(for userID: String?) {
        guard let userID else { return }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let progress = DailyProgress(
            date: formatter.string(from: Date()),
            calories: calories,
            exerciseMinutes: exerciseMinutes,
            standHours: standHours,
            challengeMet: false
        )

        UserService.saveProgress(for: userID, progress: progress) { error in
            if let error = error {
                print("Failed to save progress:", error.localizedDescription)
            } else {
                print("Progress saved.")
            }
        }
    }
}
