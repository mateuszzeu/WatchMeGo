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

    func requestAuthorization() async -> Bool {
        await withCheckedContinuation { continuation in
            healthStore.requestAuthorization(toShare: [], read: [caloriesType, exerciseType, standHourType]) { success, _ in
                continuation.resume(returning: success)
            }
        }
    }

    func fetchTodayBurnedCalories() async -> Int {
        await withCheckedContinuation { continuation in
            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

            let query = HKStatisticsQuery(quantityType: caloriesType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
                let calories = Int(result?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0)
                continuation.resume(returning: calories)
            }

            healthStore.execute(query)
        }
    }

    func fetchTodayExerciseMinutes() async -> Int {
        await withCheckedContinuation { continuation in
            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

            let query = HKStatisticsQuery(quantityType: exerciseType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
                let minutes = Int(result?.sumQuantity()?.doubleValue(for: .minute()) ?? 0)
                continuation.resume(returning: minutes)
            }

            healthStore.execute(query)
        }
    }

    func fetchTodayStandHours() async -> Int {
        await withCheckedContinuation { continuation in
            let now = Date()
            let startOfDay = Calendar.current.startOfDay(for: now)
            let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

            let query = HKSampleQuery(sampleType: standHourType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
                let stood = (samples as? [HKCategorySample])?
                    .filter { $0.value == HKCategoryValueAppleStandHour.stood.rawValue }
                    .count ?? 0
                continuation.resume(returning: stood)
            }

            healthStore.execute(query)
        }
    }
}
