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
    let pendingInvitesTable = UITableView()
    
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
        addSubview(friendsNicknameTextField)
        addSubview(inviteButton)
        
        addSubview(pendingInvitesLabel)
        addSubview(pendingInvitesTable)
        
        titleLabel.text = "Friends Section"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        titleLabel.textColor = AppStyle.Colors.textPrimary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        friendsNicknameTextField.textField.keyboardType = .default
        friendsNicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        inviteButton.translatesAutoresizingMaskIntoConstraints = false
        
        pendingInvitesLabel.text = "Pending Invites:"
        pendingInvitesLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        pendingInvitesLabel.textColor = AppStyle.Colors.textPrimary
        pendingInvitesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        pendingInvitesTable.backgroundColor = AppStyle.Colors.backgroundSecondary
        pendingInvitesTable.separatorStyle = .none
        pendingInvitesTable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
            
            friendsNicknameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 100),
            friendsNicknameTextField.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            friendsNicknameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            inviteButton.leadingAnchor.constraint(equalTo: friendsNicknameTextField.trailingAnchor, constant: 30),
            inviteButton.centerYAnchor.constraint(equalTo: friendsNicknameTextField.centerYAnchor),
            inviteButton.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor),
            inviteButton.heightAnchor.constraint(equalTo: friendsNicknameTextField.heightAnchor),
            
            pendingInvitesLabel.topAnchor.constraint(equalTo: inviteButton.bottomAnchor, constant: 20),
            pendingInvitesLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            pendingInvitesLabel.heightAnchor.constraint(equalToConstant: 30),
            
            pendingInvitesTable.topAnchor.constraint(equalTo: pendingInvitesLabel.bottomAnchor, constant: 8),
            pendingInvitesTable.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            pendingInvitesTable.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            pendingInvitesTable.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
