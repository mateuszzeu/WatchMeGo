//
//  FriendsView.swift
//  WatchMeGo
//
//  Created by Liza on 04/06/2025.
//

import UIKit

class FriendsView: UIView {
    
    let titleLabel = UILabel()
    
    let friendsNicknameTextField = PrimaryInputView(placeholder: "Enter friend’s nickname")
    let inviteButton = PrimaryButtonView(title: "Invite")
    
    let pendingInvitesLabel = UILabel()
    let pendingInvitesContainer = UIView()
    let pendingInvitesTable = UITableView()
    
    let acceptedFriendsLabel = UILabel()
    let acceptedFriendsContainer = UIView()
    let acceptedFriendsTable = UITableView()
    
    let logoutButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = AppStyle.Colors.backgroundSecondary
        
        addSubview(titleLabel)
        addSubview(friendsNicknameTextField)
        addSubview(inviteButton)
        
        addSubview(pendingInvitesLabel)
        addSubview(pendingInvitesContainer)
        pendingInvitesContainer.addSubview(pendingInvitesTable)
        
        
        addSubview(acceptedFriendsLabel)
        addSubview(acceptedFriendsContainer)
        acceptedFriendsContainer.addSubview(acceptedFriendsTable)
        
        addSubview(logoutButton)
        
        titleLabel.text = "Friends Hub"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        titleLabel.textColor = AppStyle.Colors.textPrimary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        friendsNicknameTextField.textField.keyboardType = .default
        friendsNicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        inviteButton.translatesAutoresizingMaskIntoConstraints = false
        
        pendingInvitesLabel.text = "Invites"
        pendingInvitesLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        pendingInvitesLabel.textColor = AppStyle.Colors.textPrimary
        pendingInvitesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        pendingInvitesContainer.layer.cornerRadius = 12
        pendingInvitesContainer.layer.shadowColor = UIColor.black.cgColor
        pendingInvitesContainer.layer.shadowOpacity = 0.2
        pendingInvitesContainer.layer.shadowOffset = CGSize(width: 3, height: 3)
        pendingInvitesContainer.layer.shadowRadius = 5
        pendingInvitesContainer.layer.masksToBounds = false
        pendingInvitesContainer.translatesAutoresizingMaskIntoConstraints = false
        
        pendingInvitesTable.layer.cornerRadius = 12
        pendingInvitesTable.layer.masksToBounds = true
        pendingInvitesTable.backgroundColor = AppStyle.Colors.backgroundSecondary
        pendingInvitesTable.separatorStyle = .none
        pendingInvitesTable.translatesAutoresizingMaskIntoConstraints = false
        
        acceptedFriendsLabel.text = "Friends"
        acceptedFriendsLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        acceptedFriendsLabel.textColor = AppStyle.Colors.textPrimary
        acceptedFriendsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        acceptedFriendsContainer.layer.cornerRadius = 12
        acceptedFriendsContainer.layer.shadowColor = UIColor.black.cgColor
        acceptedFriendsContainer.layer.shadowOpacity = 0.2
        acceptedFriendsContainer.layer.shadowOffset = CGSize(width: 3, height: 3)
        acceptedFriendsContainer.layer.shadowRadius = 5
        acceptedFriendsContainer.translatesAutoresizingMaskIntoConstraints = false
        
        acceptedFriendsTable.layer.cornerRadius = 12
        acceptedFriendsTable.layer.masksToBounds = true
        acceptedFriendsTable.backgroundColor = AppStyle.Colors.backgroundSecondary
        acceptedFriendsTable.separatorStyle = .none
        acceptedFriendsTable.translatesAutoresizingMaskIntoConstraints = false
        
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        logoutButton.setTitleColor(AppStyle.Colors.textPrimary, for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            friendsNicknameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            friendsNicknameTextField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            friendsNicknameTextField.heightAnchor.constraint(equalToConstant: 44),
            friendsNicknameTextField.widthAnchor.constraint(equalToConstant: 220),
            
            inviteButton.leadingAnchor.constraint(equalTo: friendsNicknameTextField.trailingAnchor, constant: 30),
            inviteButton.centerYAnchor.constraint(equalTo: friendsNicknameTextField.centerYAnchor),
            inviteButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            inviteButton.heightAnchor.constraint(equalTo: friendsNicknameTextField.heightAnchor),
            
            pendingInvitesLabel.topAnchor.constraint(equalTo: inviteButton.bottomAnchor, constant: 50),
            pendingInvitesLabel.centerXAnchor.constraint(equalTo: pendingInvitesContainer.centerXAnchor),
            pendingInvitesLabel.heightAnchor.constraint(equalToConstant: 30),
            
            pendingInvitesContainer.topAnchor.constraint(equalTo: pendingInvitesLabel.bottomAnchor, constant: 8),
            pendingInvitesContainer.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            pendingInvitesContainer.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            pendingInvitesContainer.heightAnchor.constraint(equalToConstant: 100),
            
            pendingInvitesTable.topAnchor.constraint(equalTo: pendingInvitesContainer.topAnchor),
            pendingInvitesTable.bottomAnchor.constraint(equalTo: pendingInvitesContainer.bottomAnchor),
            pendingInvitesTable.leadingAnchor.constraint(equalTo: pendingInvitesContainer.leadingAnchor),
            pendingInvitesTable.trailingAnchor.constraint(equalTo: pendingInvitesContainer.trailingAnchor),
            
            acceptedFriendsLabel.topAnchor.constraint(equalTo: pendingInvitesContainer.bottomAnchor, constant: 30),
            acceptedFriendsLabel.centerXAnchor.constraint(equalTo: acceptedFriendsContainer.centerXAnchor),
            acceptedFriendsLabel.heightAnchor.constraint(equalToConstant: 30),

            acceptedFriendsContainer.topAnchor.constraint(equalTo: acceptedFriendsLabel.bottomAnchor, constant: 8),
            acceptedFriendsContainer.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            acceptedFriendsContainer.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            acceptedFriendsContainer.heightAnchor.constraint(equalToConstant: 150),

            acceptedFriendsTable.topAnchor.constraint(equalTo: acceptedFriendsContainer.topAnchor),
            acceptedFriendsTable.bottomAnchor.constraint(equalTo: acceptedFriendsContainer.bottomAnchor),
            acceptedFriendsTable.leadingAnchor.constraint(equalTo: acceptedFriendsContainer.leadingAnchor),
            acceptedFriendsTable.trailingAnchor.constraint(equalTo: acceptedFriendsContainer.trailingAnchor),
            
            logoutButton.topAnchor.constraint(equalTo: acceptedFriendsTable.bottomAnchor, constant: 100),
            logoutButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
