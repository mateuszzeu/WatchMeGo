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
        guard let nickname = UserDefaults.standard.string(forKey: "loggedInNickname") else { return }
        let stepsGoal = UserDefaults.standard.integer(forKey: "\(nickname)_stepsGoal")

        healthKitService.fetchTodaySteps { [weak self] steps in
            self?.mainView.userProgressCard.setSteps(current: steps, goal: stepsGoal == 0 ? 10000 : stepsGoal)
        }
    }
    
    private func loadTodayStandHours() {
        guard let nickname = UserDefaults.standard.string(forKey: "loggedInNickname") else { return }
        let standGoal = UserDefaults.standard.integer(forKey: "\(nickname)_standGoal")

        healthKitService.fetchTodayStandHours { [weak self] standHours in
            self?.mainView.userProgressCard.setStandHours(current: standHours, goal: standGoal == 0 ? 12 : standGoal)
        }
    }
    
    private func loadTodayCalories() {
        guard let nickname = UserDefaults.standard.string(forKey: "loggedInNickname") else { return }
        let caloriesGoal = UserDefaults.standard.integer(forKey: "\(nickname)_caloriesGoal")

        healthKitService.fetchTodayBurnedCalories { [weak self] caloriesBurned in
            self?.mainView.userProgressCard.setCalories(current: caloriesBurned, goal: caloriesGoal == 0 ? 500 : caloriesGoal)
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
        saveDailyChallengeToFirestore()
        
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
            
            self.mainView.allyProgressCard.stepsRow.progressView.progressTintColor = AppStyle.Colors.accent
            self.mainView.allyProgressCard.stepsRow.iconView.tintColor = AppStyle.Colors.accent

            self.mainView.allyProgressCard.standRow.progressView.progressTintColor = AppStyle.Colors.accent
            self.mainView.allyProgressCard.standRow.iconView.tintColor = AppStyle.Colors.accent

            self.mainView.allyProgressCard.caloriesRow.progressView.progressTintColor = AppStyle.Colors.accent
            self.mainView.allyProgressCard.caloriesRow.iconView.tintColor = AppStyle.Colors.accent
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
            let stepsGoal = UserDefaults.standard.integer(forKey: "\(nickname)_stepsGoal") //change if different phones
            let standGoal = UserDefaults.standard.integer(forKey: "\(nickname)_standGoal")
            let caloriesGoal = UserDefaults.standard.integer(forKey: "\(nickname)_caloriesGoal")
            
            DispatchQueue.main.async {
                self?.mainView.allyProgressCard.setSteps(current: steps, goal: stepsGoal == 0 ? 10000 : stepsGoal)
                self?.mainView.allyProgressCard.setStandHours(current: stand, goal: standGoal == 0 ? 10 : standGoal)
                self?.mainView.allyProgressCard.setCalories(current: calories, goal: caloriesGoal == 0 ? 800 : caloriesGoal)
            }
        }
    }

    
    private func saveDailyChallengeToFirestore() {
        guard let nickname = UserDefaults.standard.string(forKey: "loggedInNickname") else { return }
        let date = getTodayDateString()

        let userStepsGoal = UserDefaults.standard.integer(forKey: "\(nickname)_stepsGoal")
        let userStandGoal = UserDefaults.standard.integer(forKey: "\(nickname)_standGoal")
        let userCaloriesGoal = UserDefaults.standard.integer(forKey: "\(nickname)_caloriesGoal")

        healthKitService.fetchTodaySteps { [weak self] steps in
            self?.healthKitService.fetchTodayStandHours { stand in
                self?.healthKitService.fetchTodayBurnedCalories { calories in
                    if self == nil { return }

                    let userChallengeMet = steps >= userStepsGoal && stand >= userStandGoal && calories >= userCaloriesGoal

                    if let ally = FriendService.shared.fetchCurrentAlly(), let allyNickname = ally.nickname {
                        let allyStepsGoal = UserDefaults.standard.integer(forKey: "\(allyNickname)_stepsGoal")
                        let allyStandGoal = UserDefaults.standard.integer(forKey: "\(allyNickname)_standGoal")
                        let allyCaloriesGoal = UserDefaults.standard.integer(forKey: "\(allyNickname)_caloriesGoal")

                        FirestoreService.shared.fetchProgress(for: allyNickname) { allySteps, allyStand, allyCalories in
                            let allyChallengeMet = allySteps >= allyStepsGoal &&
                                                   allyStand >= allyStandGoal &&
                                                   allyCalories >= allyCaloriesGoal

                            FirestoreService.shared.saveDailyChallengeResult(
                                date: date,
                                userNickname: nickname,
                                steps: steps,
                                stand: stand,
                                calories: calories,
                                userChallengeMet: userChallengeMet,
                                allyNickname: allyNickname,
                                allySteps: allySteps,
                                allyStand: allyStand,
                                allyCalories: allyCalories,
                                allyChallengeMet: allyChallengeMet
                            )
                        }
                    } else {
                        FirestoreService.shared.saveDailyChallengeResult(
                            date: date,
                            userNickname: nickname,
                            steps: steps,
                            stand: stand,
                            calories: calories,
                            userChallengeMet: userChallengeMet,
                            allyNickname: nil,
                            allySteps: nil,
                            allyStand: nil,
                            allyCalories: nil,
                            allyChallengeMet: nil
                        )
                    }
                }
            }
        }
    }

    
    private func getTodayDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .allyStatusChanged, object: nil)
    }
}
