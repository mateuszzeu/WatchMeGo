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
        
        loadNickname()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshRivalDisplay),
            name: .rivalStatusChanged,
            object: nil
        )
    }
    
    private func loadTodaySteps() {
        let stepsGoal = UserDefaults.standard.integer(forKey: "stepsGoal")
        
        healthKitService.fetchTodaySteps { [weak self] steps in
            guard let self = self else { return }
            self.mainView.userProgressCard.setSteps(current: steps, goal: stepsGoal == 0 ? 10000 : stepsGoal)
        }
    }
    
    private func loadTodayStandHours() {
        let standGoal = UserDefaults.standard.integer(forKey: "standGoal")
        
        healthKitService.fetchTodayStandHours { [weak self] standHours in
            guard let self = self else { return }
            self.mainView.userProgressCard.setStandHours(current: standHours, goal: standGoal == 0 ? 12 : standGoal)
        }
    }
    
    private func loadTodayCalories() {
        let caloriesGoal = UserDefaults.standard.integer(forKey: "caloriesGoal")
        
        healthKitService.fetchTodayBurnedCalories { [weak self] caloriesBurned in
            guard let self = self else { return }
            self.mainView.userProgressCard.setCalories(current: caloriesBurned, goal: caloriesGoal == 0 ? 500 : caloriesGoal)
        }
    }
    
    private func loadNickname() {
        let nickname = UserDefaults.standard.string(forKey: "loggedInNickname") ?? "Unknown User"
        mainView.nicknameLabel.text = "Hello \(nickname)"
    }
    
    @objc private func refreshData() {
        loadTodaySteps()
        loadTodayStandHours()
        loadTodayCalories()
        
        DispatchQueue.main.async {
            self.mainView.refreshControl?.endRefreshing()
        }
    }
    
    @objc private func refreshRivalDisplay() {
        if let rival = FriendService.shared.fetchCurrentRival() {
            configureRival(name: rival.nickname ?? "Unknown")
        } else {
            configureRival(name: "Rival")
        }
    }
    
    func configureRival(name: String) {
        mainView.rivalProgressCard.titleLabel.text = "\(name)'s Progress"
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .rivalStatusChanged, object: nil)
    }
}

