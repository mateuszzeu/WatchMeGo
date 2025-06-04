//
//  RegisterViewController.swift
//  WatchMeGo
//
//  Created by Liza on 02/06/2025.
//

import UIKit

class RegisterViewController: UIViewController {
    
    private let registerView = RegisterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = registerView
        setupActions()
        textFieldDidChange()
    }
    
    private func setupActions() {
        registerView.emailField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        registerView.nicknameField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        registerView.passwordField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        registerView.createAccountButton.addTarget(self, action: #selector(createUser), for: .touchUpInside)
    }
    
    private func allFieldsFilled() -> Bool {
        [registerView.emailField, registerView.nicknameField, registerView.passwordField].allSatisfy { !($0.text?.isEmpty ?? true) }
    }
    
    @objc private func createUser() {
        let email = registerView.emailField.text ?? ""
        let nickname = registerView.nicknameField.text ?? ""
        let password = registerView.passwordField.text ?? ""
        
        UserService.createUser(email: email, nickname: nickname, password: password)
        
        UserDefaults.standard.set(nickname, forKey: "loggedInNickname")
        let mainVC = MainViewController()
        navigationController?.setViewControllers([mainVC], animated: true)
    }
    
    @objc private func textFieldDidChange() {
        registerView.createAccountButton.isEnabled = allFieldsFilled()
        registerView.createAccountButton.alpha = allFieldsFilled() ? 1.0 : 0.5
    }
}
