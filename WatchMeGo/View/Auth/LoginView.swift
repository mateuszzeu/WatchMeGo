//
//  LoginView.swift
//  WatchMeGo
//
//  Created by Liza on 02/06/2025.
//

import UIKit

class LoginView: UIView {
    
    let titleLabel = UILabel()

    let nicknameField = UITextField()
    let passwordField = UITextField()

    let logInButton = UIButton(type: .system)
    let registerButton = UIButton(type: .system)

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
        stackView.addArrangedSubview(nicknameField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(logInButton)
        stackView.addArrangedSubview(registerButton)

        titleLabel.text = "Welcome Back"
        titleLabel.font = AppStyle.Fonts.largeTitle
        titleLabel.textColor = AppStyle.Colors.textPrimary
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nicknameField.autocapitalizationType = .none
        nicknameField.returnKeyType = .next
        nicknameField.applyInputFieldStyle(placeholder: "Nickname")

        passwordField.isSecureTextEntry = true
        passwordField.returnKeyType = .done
        passwordField.applyInputFieldStyle(placeholder: "Password")

        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.setTitle("Log in", for: .normal)
        logInButton.setTitleColor(.white, for: .normal)
        logInButton.backgroundColor = AppStyle.Colors.buttonText
        logInButton.layer.cornerRadius = 16
        logInButton.titleLabel?.font = AppStyle.Fonts.button

        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitle("Don't have an account? Sign up!", for: .normal)
        registerButton.setTitleColor(AppStyle.Colors.buttonText, for: .normal)
        registerButton.titleLabel?.font = AppStyle.Fonts.caption
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            nicknameField.heightAnchor.constraint(equalToConstant: 44),
            passwordField.heightAnchor.constraint(equalTo: nicknameField.heightAnchor),
            logInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
