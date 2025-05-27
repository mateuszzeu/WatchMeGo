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
            } else {
                print("HealthKit authorization failed")
            }
        }
    }
    
    @objc func showProgress() {
        print("test")
    }
    
    private func setupActions() {
        mainView.showProgressButton.addTarget(self, action: #selector(showProgress), for: .touchUpInside)
    }
    
    private func loadTodaySteps() {
        healthKitService.fetchTodaySteps { [weak self] steps in
            self?.mainView.stepsLabel.text = "steps today: \(steps)"
        }
    }

}

