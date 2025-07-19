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
    
    func requestHealthKitAccessAndFetchAll() {
        HealthKitService.shared.requestAuthorization { [weak self] success in
            DispatchQueue.main.async {
                self?.isAuthorized = success
                if success {
                    self?.refreshAll()
                }
            }
        }
    }
    
    func refreshAll() {
        HealthKitService.shared.fetchTodayBurnedCalories { [weak self] calories in
            DispatchQueue.main.async {
                self?.calories = calories
            }
        }
        HealthKitService.shared.fetchTodayExerciseMinutes { [weak self] minutes in
            DispatchQueue.main.async {
                self?.exerciseMinutes = minutes
            }
        }
        HealthKitService.shared.fetchTodayStandHours { [weak self] hours in
            DispatchQueue.main.async {
                self?.standHours = hours
            }
        }
    }
}
