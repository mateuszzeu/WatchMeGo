//
//  ChallengeView.swift
//  WatchMeGo
//
//  Created by Liza on 31/05/2025.
//

import UIKit

class ChallengeView: UIView {
    
    let titleLabel = UILabel()
    
    let stepsGoalTextField = PrimaryInputView(placeholder: "Enter your step goal")
    let stepsGoalButton = PrimaryButtonView(title: "Submit")
    
    let standGoalTextField = PrimaryInputView(placeholder: "Enter your stand goal")
    let standGoalButton = PrimaryButtonView(title: "Submit")
    
    let caloriesGoalTextField = PrimaryInputView(placeholder: "Enter your calories goal")
    let caloriesGoalButton = PrimaryButtonView(title: "Submit")
    
    let podiumContainer = UIView()
    let goldView = PodiumView(place: 0, name: "Lizunka", days: 9)
    let silverView = PodiumView(place: 1, name: "Kamilka", days: 6)
    let bronzeView = PodiumView(place: 2, name: "Martynka", days: 3)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = AppStyle.Colors.background
        
        addSubview(titleLabel)
        
        addSubview(stepsGoalTextField)
        addSubview(stepsGoalButton)
        
        addSubview(standGoalTextField)
        addSubview(standGoalButton)
        
        addSubview(caloriesGoalTextField)
        addSubview(caloriesGoalButton)
        
        addSubview(podiumContainer)
        podiumContainer.addSubview(goldView)
        podiumContainer.addSubview(silverView)
        podiumContainer.addSubview(bronzeView)
        
        titleLabel.text = "Set your challenge!"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        titleLabel.textColor = AppStyle.Colors.textPrimary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stepsGoalTextField.translatesAutoresizingMaskIntoConstraints = false
        stepsGoalButton.translatesAutoresizingMaskIntoConstraints = false
        
        standGoalTextField.translatesAutoresizingMaskIntoConstraints = false
        standGoalButton.translatesAutoresizingMaskIntoConstraints = false
        
        caloriesGoalTextField.translatesAutoresizingMaskIntoConstraints = false
        caloriesGoalButton.translatesAutoresizingMaskIntoConstraints = false
        
        podiumContainer.backgroundColor = .clear
        podiumContainer.layer.shadowColor = UIColor.black.cgColor
        podiumContainer.layer.shadowOpacity = 0.2
        podiumContainer.layer.shadowOffset = CGSize(width: 3, height: 3)
        podiumContainer.layer.shadowRadius = 5
        podiumContainer.translatesAutoresizingMaskIntoConstraints = false
        
        goldView.translatesAutoresizingMaskIntoConstraints = false
        silverView.translatesAutoresizingMaskIntoConstraints = false
        bronzeView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
            
            stepsGoalTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            stepsGoalTextField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stepsGoalTextField.heightAnchor.constraint(equalToConstant: 44),
            stepsGoalTextField.widthAnchor.constraint(equalToConstant: 220),
            
            stepsGoalButton.leadingAnchor.constraint(equalTo: stepsGoalTextField.trailingAnchor, constant: 30),
            stepsGoalButton.centerYAnchor.constraint(equalTo: stepsGoalTextField.centerYAnchor),
            stepsGoalButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            stepsGoalButton.heightAnchor.constraint(equalTo: stepsGoalTextField.heightAnchor),
            
            standGoalTextField.topAnchor.constraint(equalTo: stepsGoalTextField.bottomAnchor, constant: 20),
            standGoalTextField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            standGoalTextField.heightAnchor.constraint(equalToConstant: 44),
            standGoalTextField.widthAnchor.constraint(equalToConstant: 220),
            
            standGoalButton.leadingAnchor.constraint(equalTo: standGoalTextField.trailingAnchor, constant: 30),
            standGoalButton.centerYAnchor.constraint(equalTo: standGoalTextField.centerYAnchor),
            standGoalButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            standGoalButton.heightAnchor.constraint(equalTo: standGoalTextField.heightAnchor),
            
            caloriesGoalTextField.topAnchor.constraint(equalTo: standGoalTextField.bottomAnchor, constant: 20),
            caloriesGoalTextField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            caloriesGoalTextField.heightAnchor.constraint(equalToConstant: 44),
            caloriesGoalTextField.widthAnchor.constraint(equalToConstant: 220),
            
            caloriesGoalButton.leadingAnchor.constraint(equalTo: caloriesGoalTextField.trailingAnchor, constant: 30),
            caloriesGoalButton.centerYAnchor.constraint(equalTo: caloriesGoalTextField.centerYAnchor),
            caloriesGoalButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            caloriesGoalButton.heightAnchor.constraint(equalTo: caloriesGoalTextField.heightAnchor),
            
            podiumContainer.topAnchor.constraint(equalTo: caloriesGoalButton.bottomAnchor, constant: 40),
            podiumContainer.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            podiumContainer.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            goldView.topAnchor.constraint(equalTo: podiumContainer.topAnchor),
            goldView.leadingAnchor.constraint(equalTo: podiumContainer.leadingAnchor),
            goldView.trailingAnchor.constraint(equalTo: podiumContainer.trailingAnchor),
            goldView.heightAnchor.constraint(equalToConstant: 90),

            silverView.topAnchor.constraint(equalTo: goldView.bottomAnchor, constant: 16),
            silverView.leadingAnchor.constraint(equalTo: podiumContainer.leadingAnchor),
            silverView.trailingAnchor.constraint(equalTo: podiumContainer.trailingAnchor),
            silverView.heightAnchor.constraint(equalToConstant: 90),

            bronzeView.topAnchor.constraint(equalTo: silverView.bottomAnchor, constant: 16),
            bronzeView.leadingAnchor.constraint(equalTo: podiumContainer.leadingAnchor),
            bronzeView.trailingAnchor.constraint(equalTo: podiumContainer.trailingAnchor),
            bronzeView.heightAnchor.constraint(equalToConstant: 90),
            bronzeView.bottomAnchor.constraint(equalTo: podiumContainer.bottomAnchor)
        ])
    }
}
