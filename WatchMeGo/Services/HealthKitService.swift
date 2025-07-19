//
//  HealthKitService.swift
//  WatchMeGo
//
//  Created by Liza on 19/07/2025.
//

import Foundation
import HealthKit

final class HealthKitService {
    static let shared = HealthKitService()
    
    let healthStore = HKHealthStore()
    
    let caloriesType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
    let standHourType = HKObjectType.categoryType(forIdentifier: .appleStandHour)!
    let exerciseType = HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        healthStore.requestAuthorization(
            toShare: [],
            read: [caloriesType, exerciseType, standHourType]
        ) { success, _ in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
    
    func fetchTodayBurnedCalories(completion: @escaping (Int) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(
            quantityType: caloriesType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in
            let calories = Int(result?.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) ?? 0)
            DispatchQueue.main.async {
                completion(calories)
            }
        }
        healthStore.execute(query)
    }
    
    func fetchTodayExerciseMinutes(completion: @escaping (Int) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(
            quantityType: exerciseType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in
            let minutes = Int(result?.sumQuantity()?.doubleValue(for: HKUnit.minute()) ?? 0)
            DispatchQueue.main.async {
                completion(minutes)
            }
        }
        healthStore.execute(query)
    }
    
    func fetchTodayStandHours(completion: @escaping (Int) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKSampleQuery(
            sampleType: standHourType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
                let standHours = samples?.count ?? 0
                DispatchQueue.main.async {
                    completion(standHours)
                }
            }
        healthStore.execute(query)
    }
}
