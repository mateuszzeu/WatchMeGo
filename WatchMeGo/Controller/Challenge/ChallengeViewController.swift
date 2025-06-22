//
//  ChallengeViewController.swift
//  WatchMeGo
//
//  Created by Liza on 31/05/2025.
//

import UIKit

class ChallengeViewController: UIViewController {
    
    private let challengeView = ChallengeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = challengeView
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        challengeView.stepsGoalButton.button.addTarget(self, action: #selector(setStepsGoalButtonTapped), for: .touchUpInside)
        challengeView.standGoalButton.button.addTarget(self, action: #selector(setStandGoalButtonTapped), for: .touchUpInside)
        challengeView.caloriesGoalButton.button.addTarget(self, action: #selector(setCaloriesGoalButtonTaped), for: .touchUpInside)
        
        let goldTap = UITapGestureRecognizer(target: self, action: #selector(goldTapped))
        let silverTap = UITapGestureRecognizer(target: self, action: #selector(silverTapped))
        let bronzeTap = UITapGestureRecognizer(target: self, action: #selector(bronzeTapped))
        
        challengeView.goldView.addGestureRecognizer(goldTap)
        challengeView.silverView.addGestureRecognizer(silverTap)
        challengeView.bronzeView.addGestureRecognizer(bronzeTap)
        
        loadPodiumData()
        loadSavedGoals()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func setStepsGoalButtonTapped() {
        guard let nickname = UserDefaults.standard.string(forKey: "loggedInNickname") else { return }

        if isCompeting() {
            showAlert(title: "Action Blocked", message: "You can't change your step goal while competing.")
            return
        }

        guard let text = challengeView.stepsGoalTextField.textField.text,
              let goal = Int(text), goal > 0 else {
            showAlert(title: "Invalid Input", message: "Please enter a number greater than 0.")
            return
        }

        UserDefaults.standard.set(goal, forKey: "\(nickname)_stepsGoal")
        showAlert(title: "Saved", message: "Your steps goal has been saved.")
    }
    
    @objc private func setStandGoalButtonTapped() {
        guard let nickname = UserDefaults.standard.string(forKey: "loggedInNickname") else { return }

        if isCompeting() {
            showAlert(title: "Action Blocked", message: "You can't change your stand goal while competing.")
            return
        }

        guard let text = challengeView.standGoalTextField.textField.text,
              let goal = Int(text), goal > 0 else {
            showAlert(title: "Invalid Input", message: "Please enter a number greater than 0.")
            return
        }

        UserDefaults.standard.set(goal, forKey: "\(nickname)_standGoal")
        showAlert(title: "Saved", message: "Your stand goal has been saved.")
    }
    
    @objc private func setCaloriesGoalButtonTaped() {
        guard let nickname = UserDefaults.standard.string(forKey: "loggedInNickname") else { return }

        if isCompeting() {
            showAlert(title: "Action Blocked", message: "You can't change your calories goal while competing.")
            return
        }

        guard let text = challengeView.caloriesGoalTextField.textField.text,
              let goal = Int(text), goal > 0 else {
            showAlert(title: "Invalid Input", message: "Please enter a number greater than 0.")
            return
        }

        UserDefaults.standard.set(goal, forKey: "\(nickname)_caloriesGoal")
        showAlert(title: "Saved", message: "Your calories goal has been saved.")
    }
    
    private func isCompeting() -> Bool {
        return FriendService.shared.fetchCurrentAlly() != nil
    }
    
    @objc private func goldTapped() {
        openAllyDetails(name: "Lizunka", days: 9)
    }
    
    @objc private func silverTapped() {
        openAllyDetails(name: "Kamilka", days: 6)
    }
    
    @objc private func bronzeTapped() {
        openAllyDetails(name: "Martynka", days: 3)
    }
    
    private func openAllyDetails(name: String, days: Int) {
        let vc = PodiumAllyDetailsViewController()
        vc.title = name
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func loadSavedGoals() {
            guard let nickname = UserDefaults.standard.string(forKey: "loggedInNickname") else { return }

            let steps = UserDefaults.standard.integer(forKey: "\(nickname)_stepsGoal")
            let stand = UserDefaults.standard.integer(forKey: "\(nickname)_standGoal")
            let calories = UserDefaults.standard.integer(forKey: "\(nickname)_caloriesGoal")

            if steps > 0 {
                challengeView.stepsGoalTextField.textField.text = "\(steps)"
            }
            if stand > 0 {
                challengeView.standGoalTextField.textField.text = "\(stand)"
            }
            if calories > 0 {
                challengeView.caloriesGoalTextField.textField.text = "\(calories)"
            }
        }
    
    private func loadPodiumData() {
        let nickname = UserDefaults.standard.string(forKey: "loggedInNickname") ?? ""
        FirestoreService.shared.fetchAllyStreaks(for: nickname) { [weak self] streaks in
            let sorted = streaks.sorted { $0.value > $1.value }
            DispatchQueue.main.async {
                if sorted.indices.contains(0) {
                    self?.challengeView.goldView.nameLabel.text = sorted[0].key
                    self?.challengeView.goldView.daysLabel.text = "\(sorted[0].value) days 🔥"
                }
                if sorted.indices.contains(1) {
                    self?.challengeView.silverView.nameLabel.text = sorted[1].key
                    self?.challengeView.silverView.daysLabel.text = "\(sorted[1].value) days 🔥"
                }
                if sorted.indices.contains(2) {
                    self?.challengeView.bronzeView.nameLabel.text = sorted[2].key
                    self?.challengeView.bronzeView.daysLabel.text = "\(sorted[2].value) days 🔥"
                }
            }
        }
    }
}
