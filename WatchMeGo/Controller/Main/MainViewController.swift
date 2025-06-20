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
            selector: #selector(refreshAllyDisplay),
            name: .allyStatusChanged,
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
        refreshAllyDisplay()
        loadAllyProgressFromFirestore()
        saveProgressToFirestore()
        
        DispatchQueue.main.async {
            self.mainView.refreshControl?.endRefreshing()
        }
    }
    
    @objc private func refreshAllyDisplay() {
        if let ally = FriendService.shared.fetchCurrentAlly() {
            configureAlly(name: ally.nickname ?? "Unknown")
        } else {
            configureAlly(name: "Ally")
        }
    }
    
    func configureAlly(name: String) {
        DispatchQueue.main.async {
            self.mainView.allyProgressCard.titleLabel.text = "\(name)'s Progress"
            
            self.mainView.allyProgressCard.stepsRow.progressView.progressTintColor = .systemIndigo
            self.mainView.allyProgressCard.stepsRow.iconView.tintColor = .systemIndigo

            self.mainView.allyProgressCard.standRow.progressView.progressTintColor = .systemTeal
            self.mainView.allyProgressCard.standRow.iconView.tintColor = .systemTeal

            self.mainView.allyProgressCard.caloriesRow.progressView.progressTintColor = .systemRed
            self.mainView.allyProgressCard.caloriesRow.iconView.tintColor = .systemRed
        }
    }
    
    private func saveProgressToFirestore() {
        let nickname = UserDefaults.standard.string(forKey: "loggedInNickname") ?? "Unknown"
        
        healthKitService.fetchTodaySteps { [weak self] steps in
            self?.healthKitService.fetchTodayStandHours { standHours in
                self?.healthKitService.fetchTodayBurnedCalories { calories in
                    FirestoreService.shared.saveProgress(
                        for: nickname,
                        steps: steps,
                        stand: standHours,
                        calories: calories
                    )
                }
            }
        }
    }
    
    private func loadAllyProgressFromFirestore() {
        guard let ally = FriendService.shared.fetchCurrentAlly(),
              let nickname = ally.nickname else { return }
        
        FirestoreService.shared.fetchProgress(for: nickname) { [weak self] steps, stand, calories in
            DispatchQueue.main.async {
                self?.mainView.allyProgressCard.setSteps(current: steps, goal: 10000)
                self?.mainView.allyProgressCard.setStandHours(current: stand, goal: 10)
                self?.mainView.allyProgressCard.setCalories(current: calories, goal: 800)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .allyStatusChanged, object: nil)
    }
}

