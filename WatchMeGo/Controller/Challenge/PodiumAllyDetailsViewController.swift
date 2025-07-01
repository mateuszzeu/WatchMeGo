//
//  PodiumAllyDetailsViewController.swift
//  WatchMeGo
//
//  Created by Liza on 20/06/2025.
//

import UIKit

class PodiumAllyDetailsViewController: UIViewController {

    private let allyNickname: String
    private let currentStreak: Int
    private var dailyResults: [DailyChallengeResult] = []

    private let detailsView = PodiumAllyDetailsView()

    init(allyNickname: String, currentStreak: Int) {
        self.allyNickname = allyNickname
        self.currentStreak = currentStreak
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailsView
        title = allyNickname
        fetchDailyResults()
    }

    private func fetchDailyResults() {
        guard let userNickname = UserDefaults.standard.string(forKey: "loggedInNickname") else { return }

        FirestoreService.shared.fetchDailyChallengeResults(for: userNickname, allyNickname: allyNickname) { [weak self] results in
            DispatchQueue.main.async {
                self?.dailyResults = results
                self?.updateUI()
            }
        }
    }

    private func updateUI() {
        detailsView.currentStreakLabel.text = "Current streak: \(currentStreak) days"
        detailsView.longestStreakLabel.text = "Longest streak: \(calculateLongestStreak()) days"

        if let latest = dailyResults.first {
            let stepsGoal = UserDefaults.standard.integer(forKey: "\(allyNickname)_stepsGoal")
            let standGoal = UserDefaults.standard.integer(forKey: "\(allyNickname)_standGoal")
            let caloriesGoal = UserDefaults.standard.integer(forKey: "\(allyNickname)_caloriesGoal")

            detailsView.progressCard.setSteps(current: latest.allySteps ?? 0, goal: stepsGoal == 0 ? 10000 : stepsGoal)
            detailsView.progressCard.setStandHours(current: latest.allyStand ?? 0, goal: standGoal == 0 ? 10 : standGoal)
            detailsView.progressCard.setCalories(current: latest.allyCalories ?? 0, goal: caloriesGoal == 0 ? 800 : caloriesGoal)
        }

        detailsView.displayDailyResults(dailyResults)
    }

    private func calculateLongestStreak() -> Int {
        var longest = 0
        var current = 0
        for result in dailyResults.sorted(by: { $0.date < $1.date }) {
            if result.bothChallengeMet {
                current += 1
                longest = max(longest, current)
            } else {
                current = 0
            }
        }
        return longest
    }
}
