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
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
            
            stepsGoalTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 100),
            stepsGoalTextField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stepsGoalTextField.heightAnchor.constraint(equalToConstant: 44),
            stepsGoalTextField.widthAnchor.constraint(equalTo: caloriesGoalTextField.widthAnchor),
            
            stepsGoalButton.leadingAnchor.constraint(equalTo: stepsGoalTextField.trailingAnchor, constant: 30),
            stepsGoalButton.centerYAnchor.constraint(equalTo: stepsGoalTextField.centerYAnchor),
            stepsGoalButton.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor),
            stepsGoalButton.heightAnchor.constraint(equalTo: stepsGoalTextField.heightAnchor),
            
            standGoalTextField.topAnchor.constraint(equalTo: stepsGoalTextField.bottomAnchor, constant: 20),
            standGoalTextField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            standGoalTextField.heightAnchor.constraint(equalToConstant: 44),
            standGoalTextField.widthAnchor.constraint(equalTo: caloriesGoalTextField.widthAnchor),
            
            standGoalButton.leadingAnchor.constraint(equalTo: standGoalTextField.trailingAnchor, constant: 30),
            standGoalButton.centerYAnchor.constraint(equalTo: standGoalTextField.centerYAnchor),
            standGoalButton.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor),
            standGoalButton.heightAnchor.constraint(equalTo: standGoalTextField.heightAnchor),
            
            caloriesGoalTextField.topAnchor.constraint(equalTo: standGoalTextField.bottomAnchor, constant: 20),
            caloriesGoalTextField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            caloriesGoalTextField.heightAnchor.constraint(equalToConstant: 44),
            
            caloriesGoalButton.leadingAnchor.constraint(equalTo: caloriesGoalTextField.trailingAnchor, constant: 30),
            caloriesGoalButton.centerYAnchor.constraint(equalTo: caloriesGoalTextField.centerYAnchor),
            caloriesGoalButton.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor),
            caloriesGoalButton.heightAnchor.constraint(equalTo: caloriesGoalTextField.heightAnchor)
        ])
    }
}
