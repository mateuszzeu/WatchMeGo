//
//  HealthKitService.swift
//  WatchMeGo
//
//  Created by Liza on 26/05/2025.
//

import Foundation
import HealthKit

class HealthKitService {
    
    let healthStore = HKHealthStore()
    let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    let standHourType = HKCategoryType.categoryType(forIdentifier: .appleStandHour)!
    let caloriesBurnedType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        healthStore.requestAuthorization(toShare: [], read: [stepsType, standHourType, caloriesBurnedType]) { [weak self] success, error in
            completion(success)
        }
    }
    
    func fetchTodaySteps(completion: @escaping (Int) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            let steps = Int(result?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0)
            
            DispatchQueue.main.async {
                completion(steps)
            }
        }
        healthStore.execute(query)
    }
    
    func fetchTodayStandHours(completion: @escaping (Int) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: standHourType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, result, _ in
            let standHours = result?.count ?? 0
            
            DispatchQueue.main.async {
                completion(standHours)
            }
        }
        healthStore.execute(query)
    }
    
    func fetchTodayBurnedCalories(completion: @escaping (Int) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: caloriesBurnedType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            let calories = Int(result?.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) ?? 0)
            
            DispatchQueue.main.async {
                completion(calories)
            }
        }
        healthStore.execute(query)
    }
}
