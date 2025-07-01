//
//  RegisterView.swift
//  WatchMeGo
//
//  Created by Liza on 02/06/2025.
//

import UIKit

class RegisterView: UIView {

    let titleLabel = UILabel()

    let emailField = UITextField()
    let nicknameField = UITextField()
    let passwordField = UITextField()
    let createAccountButton = UIButton(type: .system)

    private let stackView = UIStackView()
    
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
        addSubview(stackView)

        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(nicknameField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(createAccountButton)

        titleLabel.text = "Create Account"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textColor = AppStyle.Colors.textPrimary
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailField.autocapitalizationType = .none
        emailField.keyboardType = .emailAddress
        emailField.returnKeyType = .next
        emailField.applyInputFieldStyle(placeholder: "Email")

        nicknameField.autocapitalizationType = .none
        nicknameField.returnKeyType = .next
        nicknameField.applyInputFieldStyle(placeholder: "Nickname")

        passwordField.isSecureTextEntry = true
        passwordField.returnKeyType = .done
        passwordField.applyInputFieldStyle(placeholder: "Password")

        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        createAccountButton.setTitle("Register", for: .normal)
        createAccountButton.isEnabled = false
        createAccountButton.setTitleColor(.white, for: .normal)
        createAccountButton.backgroundColor = AppStyle.Colors.buttonText
        createAccountButton.layer.cornerRadius = 16
        createAccountButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            emailField.heightAnchor.constraint(equalToConstant: 44),
            nicknameField.heightAnchor.constraint(equalTo: emailField.heightAnchor),
            passwordField.heightAnchor.constraint(equalTo: emailField.heightAnchor),
            createAccountButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
