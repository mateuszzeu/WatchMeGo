//
//  MainViewModel.swift
//  WatchMeGo
//
//  Created by Liza on 19/07/2025.
//
import Foundation

@MainActor
@Observable
final class MainViewModel {
    
    private enum ActivityGoal {
        static let calories = 500
        static let exerciseMinutes = 80
        static let standHours = 10
    }
    
    var isAuthorized = false
    var calories = 0
    var exerciseMinutes = 0
    var standHours = 0
    
    var competitiveUser: AppUser? = nil
    
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
        
        if let userID, let user = try? await UserService.fetchUser(id: userID),
           let competitiveID = user.activeCompetitionWith {
            competitiveUser = try? await UserService.fetchUser(id: competitiveID)
        } else {
            competitiveUser = nil
        }
    }
    
    private func saveProgress(for userID: String?) async {
        guard let userID else {
            ErrorHandler.shared.handle(AppError.unknownError)
            return
        }
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        
        let dateString = dateFormat.string(from: Date())
        
        let challengeMet = calories >= ActivityGoal.calories &&
            exerciseMinutes >= ActivityGoal.exerciseMinutes &&
            standHours >= ActivityGoal.standHours
        
        let progress = DailyProgress(
            calories: calories,
            exerciseMinutes: exerciseMinutes,
            standHours: standHours,
            challengeMet: challengeMet
        )
        
        do {
            try await UserService.saveProgress(for: userID, date: dateString, progress: progress)
        } catch {
            ErrorHandler.shared.handle(error)
        }
    }
}
