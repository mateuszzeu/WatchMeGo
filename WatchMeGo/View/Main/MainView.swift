//
//  MainView.swift
//  WatchMeGo
//
//  Created by Liza on 23/05/2025.
//
import UIKit

class MainView: UIScrollView {
    
    let titleLabel = UILabel()
    
    let userProgressCard = ProgressCardView()
    let nicknameLabel = UILabel()
    
    let allyProgressCard = ProgressCardView()
    
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
        addSubview(userProgressCard)
        
        addSubview(nicknameLabel)
        
        addSubview(allyProgressCard)
        
        titleLabel.text = "WatchMeGo"
        titleLabel.font = AppStyle.Fonts.largeTitle
        titleLabel.textColor = AppStyle.Colors.textPrimary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        userProgressCard.translatesAutoresizingMaskIntoConstraints = false
        
        nicknameLabel.font = AppStyle.Fonts.caption
        nicknameLabel.textColor = AppStyle.Colors.textSecondary
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
          
        allyProgressCard.translatesAutoresizingMaskIntoConstraints = false
        allyProgressCard.titleLabel.text = "Ally's Progress"
        
        NSLayoutConstraint.activate([
            nicknameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nicknameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            
            titleLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            userProgressCard.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            userProgressCard.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            userProgressCard.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            userProgressCard.heightAnchor.constraint(equalToConstant: 250),
       
            allyProgressCard.topAnchor.constraint(equalTo: userProgressCard.bottomAnchor, constant: 50),
            allyProgressCard.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            allyProgressCard.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            allyProgressCard.heightAnchor.constraint(equalToConstant: 250),
        ])
    }
}
