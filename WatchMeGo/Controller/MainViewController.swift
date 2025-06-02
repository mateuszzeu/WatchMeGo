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
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        mainView.refreshControl = refresh
        
        healthKitService.requestAuthorization { [weak self] success in
            if success {
                self?.refreshData()
            } else {
                print("HealthKit authorization failed")
            }
        }
    }
    
    private func loadTodaySteps() {
        let stepsGoal = UserDefaults.standard.integer(forKey: "stepsGoal")
        
        healthKitService.fetchTodaySteps { [weak self] steps in
            guard let self = self else { return }
            self.mainView.progressCard.setSteps(current: steps, goal: stepsGoal == 0 ? 10000 : stepsGoal)
        }
    }
    
    private func loadTodayStandHours() {
        let standGoal = UserDefaults.standard.integer(forKey: "standGoal")
        
        healthKitService.fetchTodayStandHours { [weak self] standHours in
            guard let self = self else { return }
            self.mainView.progressCard.setStandHours(current: standHours, goal: standGoal == 0 ? 12 : standGoal)
        }
    }
    
    private func loadTodayCalories() {
        let caloriesGoal = UserDefaults.standard.integer(forKey: "caloriesGoal")
        
        healthKitService.fetchTodayBurnedCalories { [weak self] caloriesBurned in
            guard let self = self else { return }
            self.mainView.progressCard.setCalories(current: caloriesBurned, goal: caloriesGoal == 0 ? 500 : caloriesGoal)
        }
    }
    
    @objc private func refreshData() {
        loadTodaySteps()
        loadTodayStandHours()
        loadTodayCalories()

        DispatchQueue.main.async {
            self.mainView.refreshControl?.endRefreshing()
        }
    }
}

