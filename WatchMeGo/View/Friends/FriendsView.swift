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

    private let contentStack = UIStackView()
    private let inputStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = AppStyle.Colors.background

        addSubview(contentStack)
        contentStack.axis = .vertical
        contentStack.spacing = 24
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(inputStack)
        contentStack.addArrangedSubview(pendingInvitesLabel)
        contentStack.addArrangedSubview(pendingInvitesContainer)
        contentStack.addArrangedSubview(acceptedFriendsLabel)
        contentStack.addArrangedSubview(acceptedFriendsContainer)
        contentStack.addArrangedSubview(logoutButton)

        inputStack.axis = .horizontal
        inputStack.spacing = 12
        inputStack.addArrangedSubview(friendsNicknameTextField)
        inputStack.addArrangedSubview(inviteButton)
        inputStack.translatesAutoresizingMaskIntoConstraints = false

        pendingInvitesContainer.addSubview(pendingInvitesTable)
        acceptedFriendsContainer.addSubview(acceptedFriendsTable)

        titleLabel.text = "Friends Hub"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textColor = AppStyle.Colors.textPrimary
        titleLabel.setContentHuggingPriority(.required, for: .vertical)

        friendsNicknameTextField.textField.keyboardType = .default

        inviteButton.translatesAutoresizingMaskIntoConstraints = false

        pendingInvitesLabel.text = "Invites"
        pendingInvitesLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        pendingInvitesLabel.textColor = AppStyle.Colors.textPrimary

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
        acceptedFriendsLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        acceptedFriendsLabel.textColor = AppStyle.Colors.textPrimary

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
            contentStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            friendsNicknameTextField.heightAnchor.constraint(equalToConstant: 44),
            inviteButton.widthAnchor.constraint(equalToConstant: 100),

            pendingInvitesContainer.heightAnchor.constraint(equalToConstant: 120),
            acceptedFriendsContainer.heightAnchor.constraint(equalToConstant: 160),

            pendingInvitesTable.topAnchor.constraint(equalTo: pendingInvitesContainer.topAnchor),
            pendingInvitesTable.bottomAnchor.constraint(equalTo: pendingInvitesContainer.bottomAnchor),
            pendingInvitesTable.leadingAnchor.constraint(equalTo: pendingInvitesContainer.leadingAnchor),
            pendingInvitesTable.trailingAnchor.constraint(equalTo: pendingInvitesContainer.trailingAnchor),

            acceptedFriendsTable.topAnchor.constraint(equalTo: acceptedFriendsContainer.topAnchor),
            acceptedFriendsTable.bottomAnchor.constraint(equalTo: acceptedFriendsContainer.bottomAnchor),
            acceptedFriendsTable.leadingAnchor.constraint(equalTo: acceptedFriendsContainer.leadingAnchor),
            acceptedFriendsTable.trailingAnchor.constraint(equalTo: acceptedFriendsContainer.trailingAnchor)
        ])
    }
}
