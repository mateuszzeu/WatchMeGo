//
//  LoginView.swift
//  WatchMeGo
//
//  Created by Liza on 02/06/2025.
//

import UIKit

class LoginView: UIView {
    
    let nicknameField = UITextField()
    let passwordField = UITextField()
    let logInButton = UIButton(type: .system)
    let registerButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = AppStyle.Colors.background
        
        addSubview(nicknameField)
        addSubview(passwordField)
        addSubview(logInButton)
        addSubview(registerButton)
        
        nicknameField.autocapitalizationType = .none
        nicknameField.returnKeyType = .next
        nicknameField.applyInputFieldStyle(placeholder: "Write your nickname...")

        passwordField.isSecureTextEntry = true
        passwordField.returnKeyType = .done
        passwordField.applyInputFieldStyle(placeholder: "Write your password...")

        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.setTitle("Log in", for: .normal)
        logInButton.setTitleColor(AppStyle.Colors.textSecondary, for: .normal)
        logInButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)

        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitle("Don't have an account? Sign up!", for: .normal)
        registerButton.setTitleColor(AppStyle.Colors.buttonText, for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        NSLayoutConstraint.activate([
            nicknameField.centerXAnchor.constraint(equalTo: centerXAnchor),
            nicknameField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 120),
            nicknameField.widthAnchor.constraint(equalToConstant: 250),
            nicknameField.heightAnchor.constraint(equalToConstant: 35),
            
            passwordField.centerXAnchor.constraint(equalTo: centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: nicknameField.bottomAnchor, constant: 20),
            passwordField.widthAnchor.constraint(equalToConstant: 250),
            passwordField.heightAnchor.constraint(equalToConstant: 35),
            passwordField.widthAnchor.constraint(equalTo: nicknameField.widthAnchor),
            
            logInButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            logInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            logInButton.widthAnchor.constraint(equalTo: nicknameField.widthAnchor),
            
            registerButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 20),
            registerButton.widthAnchor.constraint(equalTo: nicknameField.widthAnchor),
        ])
    }
}
