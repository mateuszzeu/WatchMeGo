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
        guard isAuthorized else {
            ErrorHandler.shared.handle(AppError.authenticationError)
            return
        }
        
        async let cals = HealthKitService.shared.fetchTodayBurnedCalories()
        async let mins = HealthKitService.shared.fetchTodayExerciseMinutes()
        async let hours = HealthKitService.shared.fetchTodayStandHours()
        
        calories = await cals
        exerciseMinutes = await mins
        standHours = await hours
        
        await saveProgress(for: userID)
    }
    
    private func saveProgress(for userID: String?) async {
        guard let userID else {
            ErrorHandler.shared.handle(AppError.unknownError)
            return
        }
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        
        let progress = DailyProgress(
            date: dateFormat.string(from: Date()),
            calories: calories,
            exerciseMinutes: exerciseMinutes,
            standHours: standHours,
            challengeMet: false
        )
        
        do {
            try await UserService.saveProgress(for: userID, progress: progress)
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }
}
