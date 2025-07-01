//
//  PodiumAllyDetailsView.swift
//  WatchMeGo
//
//  Created by Liza on 20/06/2025.
//

import UIKit

class PodiumAllyDetailsView: UIView {

    let progressCard = ProgressCardView()
    let currentStreakLabel = UILabel()
    let longestStreakLabel = UILabel()
    let resultsStack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = AppStyle.Colors.background

        addSubview(progressCard)
        addSubview(currentStreakLabel)
        addSubview(longestStreakLabel)
        addSubview(resultsStack)

        progressCard.translatesAutoresizingMaskIntoConstraints = false

        currentStreakLabel.font = .systemFont(ofSize: 18, weight: .medium)
        currentStreakLabel.textColor = AppStyle.Colors.textPrimary
        currentStreakLabel.textAlignment = .center
        currentStreakLabel.translatesAutoresizingMaskIntoConstraints = false

        longestStreakLabel.font = .systemFont(ofSize: 15)
        longestStreakLabel.textColor = AppStyle.Colors.textSecondary
        longestStreakLabel.textAlignment = .center
        longestStreakLabel.translatesAutoresizingMaskIntoConstraints = false

        resultsStack.axis = .vertical
        resultsStack.spacing = 8
        resultsStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            progressCard.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            progressCard.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            progressCard.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            progressCard.heightAnchor.constraint(equalToConstant: 250),

            currentStreakLabel.topAnchor.constraint(equalTo: progressCard.bottomAnchor, constant: 20),
            currentStreakLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            longestStreakLabel.topAnchor.constraint(equalTo: currentStreakLabel.bottomAnchor, constant: 8),
            longestStreakLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            resultsStack.topAnchor.constraint(equalTo: longestStreakLabel.bottomAnchor, constant: 20),
            resultsStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            resultsStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])
    }

    func displayDailyResults(_ results: [DailyChallengeResult]) {
        resultsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for result in results {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14)
            label.textColor = AppStyle.Colors.textPrimary
            label.text = "\(result.date): \(result.bothChallengeMet ? "✅" : "❌")"
            resultsStack.addArrangedSubview(label)
        }
    }
}
