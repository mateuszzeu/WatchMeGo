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
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func setStepsGoalButtonTapped() {
        guard let text = challengeView.stepsGoalTextField.textField.text,
              let goal = Int(text), goal > 0 else {
            showAlert(title: "Invalid Input", message: "Please enter a number greater than 0.")
            return
        }
        
        UserDefaults.standard.set(goal, forKey: "stepsGoal")
        showAlert(title: "Saved", message: "Your steps goal has been saved.")
    }
    
    @objc private func setStandGoalButtonTapped() {
        guard let text = challengeView.standGoalTextField.textField.text,
              let goal = Int(text), goal > 0 else {
            showAlert(title: "Invalid Input", message: "Please enter a number greater than 0.")
            return
        }
        
        UserDefaults.standard.set(goal, forKey: "standGoal")
        showAlert(title: "Saved", message: "Your stand goal has been saved.")
    }
    
    @objc private func setCaloriesGoalButtonTaped() {
        guard let text = challengeView.caloriesGoalTextField.textField.text,
              let goal = Int(text), goal > 0 else {
            showAlert(title: "Invalid Input", message: "Please enter a number greater than 0.")
            return
        }
        
        UserDefaults.standard.set(goal, forKey: "caloriesGoal")
        showAlert(title: "Saved", message: "Your calories goal has been saved.")
    }
}
