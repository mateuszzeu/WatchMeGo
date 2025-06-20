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
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func setStepsGoalButtonTapped() {
        if isCompeting() {
            showAlert(title: "Action Blocked", message: "You can't change your step goal while competing.")
            return
        }
        
        guard let text = challengeView.stepsGoalTextField.textField.text,
              let goal = Int(text), goal > 0 else {
            showAlert(title: "Invalid Input", message: "Please enter a number greater than 0.")
            return
        }
        
        UserDefaults.standard.set(goal, forKey: "stepsGoal")
        showAlert(title: "Saved", message: "Your steps goal has been saved.")
    }
    
    @objc private func setStandGoalButtonTapped() {
        if isCompeting() {
            showAlert(title: "Action Blocked", message: "You can't change your stand goal while competing.")
            return
        }
        
        guard let text = challengeView.standGoalTextField.textField.text,
              let goal = Int(text), goal > 0 else {
            showAlert(title: "Invalid Input", message: "Please enter a number greater than 0.")
            return
        }
        
        UserDefaults.standard.set(goal, forKey: "standGoal")
        showAlert(title: "Saved", message: "Your stand goal has been saved.")
    }
    
    @objc private func setCaloriesGoalButtonTaped() {
        if isCompeting() {
            showAlert(title: "Action Blocked", message: "You can't change your calories goal while competing.")
            return
        }
        
        guard let text = challengeView.caloriesGoalTextField.textField.text,
              let goal = Int(text), goal > 0 else {
            showAlert(title: "Invalid Input", message: "Please enter a number greater than 0.")
            return
        }
        
        UserDefaults.standard.set(goal, forKey: "caloriesGoal")
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
}
