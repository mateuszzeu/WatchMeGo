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
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        healthStore.requestAuthorization(toShare: [], read: [stepsType]) { [weak self] success, error in
            completion(success)
        }
    }
    
    func fetchTodaySteps(completion: @escaping (Int) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepsType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            var steps = 0
            if let sum = result?.sumQuantity() {
                steps = Int(sum.doubleValue(for: HKUnit.count()))
            }
            DispatchQueue.main.async {
                completion(steps)
            }
        }
        healthStore.execute(query)
    }
}
