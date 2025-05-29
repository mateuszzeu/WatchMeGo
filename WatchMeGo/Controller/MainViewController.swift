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
    private let healthKitService = HealthKitService()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        
        healthKitService.requestAuthorization { [weak self] success in
            if success {
                self?.loadTodaySteps()
                self?.loadTodayStandHours()
                self?.loadTodayCalories()
            } else {
                print("HealthKit authorization failed")
            }
        }
    }
    
    private func loadTodaySteps() {
        healthKitService.fetchTodaySteps { [weak self] steps in
            guard let self = self else { return }
            self.mainView.progressCard.setSteps(current: steps, goal: 10000)
        }
    }
    
    private func loadTodayStandHours() {
        healthKitService.fetchTodayStandHours { [weak self] standHours in
            guard let self = self else { return }
            self.mainView.progressCard.setStandHours(current: standHours, goal: 12)
        }
    }
    
    private func loadTodayCalories() {
        healthKitService.fetchTodayBurnedCalories { [weak self] caloriesBurned in
            guard let self = self else { return }
            self.mainView.progressCard.setCalories(current: caloriesBurned, goal: 800)
        }
    }
}

