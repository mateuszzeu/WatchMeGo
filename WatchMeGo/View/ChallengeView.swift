//
//  ChallengeView.swift
//  WatchMeGo
//
//  Created by Liza on 31/05/2025.
//

import UIKit

class ChallengeView: UIView {
    
    let titleLabel = UILabel()
    let stepsGoalTextField = GoalInputView(placeholder: "Enter your step goal")
    let setStepsGoalButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(stepsGoalTextField)
        addSubview(setStepsGoalButton)
        
        titleLabel.text = "Set your challenge!"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stepsGoalTextField.translatesAutoresizingMaskIntoConstraints = false
        
        setStepsGoalButton.setTitle("Set Goal", for: .normal)
        setStepsGoalButton.backgroundColor = .systemBlue
        setStepsGoalButton.setTitleColor(.white, for: .normal)
        setStepsGoalButton.layer.cornerRadius = 10
        setStepsGoalButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 18, bottom: 8, right: 18)
        setStepsGoalButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        setStepsGoalButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
            
            stepsGoalTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 100),
            stepsGoalTextField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stepsGoalTextField.heightAnchor.constraint(equalToConstant: 40),
            
            setStepsGoalButton.leadingAnchor.constraint(equalTo: stepsGoalTextField.trailingAnchor, constant: 30),
            setStepsGoalButton.centerYAnchor.constraint(equalTo: stepsGoalTextField.centerYAnchor),
            setStepsGoalButton.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor),
            setStepsGoalButton.heightAnchor.constraint(equalTo: stepsGoalTextField.heightAnchor)
        ])
    }
}
