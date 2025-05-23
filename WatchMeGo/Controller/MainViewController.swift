//
//  MainViewController.swift
//  WatchMeGo
//
//  Created by Liza on 22/05/2025.
//

import UIKit
import HealthKit

class MainViewController: UIViewController {
    
    private let mainView = MainView()
    
    let healthStore = HKHealthStore()
    let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        setupActions()
        
        healthStore.requestAuthorization(toShare: [], read: [stepsType]) { [weak self] success, error in
            if success {
                self?.fetchTodaySteps()
            } else {
                print("HealthKit authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    @objc func showProgress() {
        print("test")
    }
    
    private func setupActions() {
        mainView.showProgressButton.addTarget(self, action: #selector(showProgress), for: .touchUpInside)
    }
    
    func fetchTodaySteps() {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            var steps = 0
            if let sum = result?.sumQuantity() {
                steps = Int(sum.doubleValue(for: HKUnit.count()))
            }
            DispatchQueue.main.async {
                self.mainView.stepsLabel.text = "Steps today: \(steps)"
            }
        }
        healthStore.execute(query)
    }

}

