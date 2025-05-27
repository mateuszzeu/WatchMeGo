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
        setupActions()
        
        healthKitService.requestAuthorization { [weak self] success in
            if success {
                self?.loadTodaySteps()
                self?.loadTodayStandHours()
            } else {
                print("HealthKit authorization failed")
            }
        }
    }
    
    private func setupActions() {
        mainView.setGoalButton.addTarget(self, action: #selector(setGoal), for: .touchUpInside)
    }
    
    private func loadTodaySteps() {
        healthKitService.fetchTodaySteps { [weak self] steps in
            guard let self = self else { return }
            
            let stepGoal = self.getStepGoal()
            
            self.mainView.stepsLabel.text = "steps today: \(steps)/\(stepGoal)"
            
            let progress = min(Float(steps) / Float(stepGoal), 1.0)
            self.mainView.progressView.setProgress(progress, animated: true)
        }
    }
    
    private func loadTodayStandHours() {
        healthKitService.fetchTodayStandHours { [weak self] standHours in
            guard let self = self else { return }
            let goal = 12
            self.mainView.standHoursLabel.text = "stand hours today: \(standHours)/\(goal)"
        }
    }
    
    func getStepGoal() -> Int {
        let savedGoal = UserDefaults.standard.integer(forKey: "stepGoal")
        return savedGoal == 0 ? 8000 : savedGoal
    }
    
    @objc func setGoal() {
        let alert = UIAlertController(title: "Set Step Goal", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.keyboardType = .numberPad
            textField.placeholder = "Enter your daily goal"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let goalText = alert.textFields?.first?.text, let goal = Int(goalText) {
                UserDefaults.standard.set(goal, forKey: "stepGoal")
                self.loadTodaySteps()
            }
        }
        
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

