//
//  ChallengeView.swift
//  WatchMeGo
//
//  Created by Liza on 31/05/2025.
//

import UIKit

class ChallengeView: UIView {
    
    let titleLabel = UILabel()
    let stepGoalTextField = UITextField()
    let confrimButton = UIButton(type: .system)
    
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
        addSubview(stepGoalTextField)
        addSubview(confrimButton)
        
        titleLabel.text = "Set your challenge!"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stepGoalTextField.placeholder = "Enter your step goal"
        stepGoalTextField.borderStyle = .roundedRect
        stepGoalTextField.keyboardType = .numberPad
        stepGoalTextField.translatesAutoresizingMaskIntoConstraints = false
        
        confrimButton.setTitle("Set Goal", for: .normal)
        confrimButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        confrimButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
            
            stepGoalTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 100),
            stepGoalTextField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stepGoalTextField.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            stepGoalTextField.heightAnchor.constraint(equalToConstant: 40),
            
            confrimButton.topAnchor.constraint(equalTo: stepGoalTextField.bottomAnchor, constant: 50),
            confrimButton.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
            confrimButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
