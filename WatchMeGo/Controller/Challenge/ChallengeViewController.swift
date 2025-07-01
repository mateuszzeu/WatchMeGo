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
        challengeView.caloriesGoalButton.button.addTarget(self, action: #selector(setCaloriesGoalButtonTapped), for: .touchUpInside)
        
        let goldTap = UITapGestureRecognizer(target: self, action: #selector(goldTapped))
        let silverTap = UITapGestureRecognizer(target: self, action: #selector(silverTapped))
        let bronzeTap = UITapGestureRecognizer(target: self, action: #selector(bronzeTapped))
        
        challengeView.goldView.addGestureRecognizer(goldTap)
        challengeView.silverView.addGestureRecognizer(silverTap)
        challengeView.bronzeView.addGestureRecognizer(bronzeTap)
        
        loadPodiumData()
        //loadSavedGoals()
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
        
        clearTextField(challengeView.stepsGoalTextField.textField)
        
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
        
        clearTextField(challengeView.standGoalTextField.textField)
        
        showAlert(title: "Saved", message: "Your stand goal has been saved.")
    }
    
    @objc private func setCaloriesGoalButtonTapped() {
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
        
        clearTextField(challengeView.caloriesGoalTextField.textField)
        
        showAlert(title: "Saved", message: "Your calories goal has been saved.")
    }
    
    private func isCompeting() -> Bool {
        return FriendService.shared.fetchCurrentAlly() != nil
    }
    
    @objc private func goldTapped() {
        guard let name = challengeView.goldView.name, let days = challengeView.goldView.days else { return }
        openAllyDetails(name: name, days: days)
    }

    @objc private func silverTapped() {
        guard let name = challengeView.silverView.name, let days = challengeView.silverView.days else { return }
        openAllyDetails(name: name, days: days)
    }

    @objc private func bronzeTapped() {
        guard let name = challengeView.bronzeView.name, let days = challengeView.bronzeView.days else { return }
        openAllyDetails(name: name, days: days)
    }
    
    private func openAllyDetails(name: String, days: Int) {
        let vc = PodiumAllyDetailsViewController(allyNickname: name, currentStreak: days)
        vc.title = name
        navigationController?.pushViewController(vc, animated: true)
    }
    
//    private func loadSavedGoals() {
//            guard let nickname = UserDefaults.standard.string(forKey: "loggedInNickname") else { return }
//
//            let steps = UserDefaults.standard.integer(forKey: "\(nickname)_stepsGoal")
//            let stand = UserDefaults.standard.integer(forKey: "\(nickname)_standGoal")
//            let calories = UserDefaults.standard.integer(forKey: "\(nickname)_caloriesGoal")
//
//            if steps > 0 {
//                challengeView.stepsGoalTextField.textField.text = "\(steps)"
//            }
//            if stand > 0 {
//                challengeView.standGoalTextField.textField.text = "\(stand)"
//            }
//            if calories > 0 {
//                challengeView.caloriesGoalTextField.textField.text = "\(calories)"
//            }
//        }
    
    private func loadPodiumData() {
        let nickname = UserDefaults.standard.string(forKey: "loggedInNickname") ?? ""
        FirestoreService.shared.fetchAllyStreaks(for: nickname) { [weak self] streaks in
            let sorted = streaks.sorted { $0.value > $1.value }
            DispatchQueue.main.async {
                let views = [self?.challengeView.goldView, self?.challengeView.silverView, self?.challengeView.bronzeView]
                for (index, view) in views.enumerated() {
                    if index < sorted.count {
                        let result = sorted[index]
                        view?.update(name: result.key, days: result.value)
                    } else {
                        view?.update(name: nil, days: nil)
                    }
                }
            }
        }
    }
}
