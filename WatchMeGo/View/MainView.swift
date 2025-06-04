//
//  MainView.swift
//  WatchMeGo
//
//  Created by Liza on 23/05/2025.
//
import UIKit

class MainView: UIScrollView {
    
    let titleLabel = UILabel()
    let progressCard = ProgressCardView()
    let nicknameLabel = UILabel()
    let logoutButton = UIButton(type: .system)
    
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
        addSubview(progressCard)
        
        addSubview(nicknameLabel)
        addSubview(logoutButton)
        
        
        titleLabel.text = "WatchMeGo"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textColor = AppStyle.Colors.textPrimary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        progressCard.translatesAutoresizingMaskIntoConstraints = false
        
        nicknameLabel.font = UIFont.systemFont(ofSize: 13)
        nicknameLabel.textColor = AppStyle.Colors.textSecondary
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        logoutButton.setTitleColor(AppStyle.Colors.textPrimary, for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nicknameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nicknameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            progressCard.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            progressCard.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            progressCard.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            progressCard.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            
            logoutButton.topAnchor.constraint(equalTo: progressCard.bottomAnchor, constant: 240),
            logoutButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
