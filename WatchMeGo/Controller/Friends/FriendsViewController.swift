//
//  FriendsViewController.swift
//  WatchMeGo
//
//  Created by Liza on 04/06/2025.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let friendsView = FriendsView()
    private var pendingInvites: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = friendsView
        
        friendsView.pendingInvitesTable.delegate = self
        friendsView.pendingInvitesTable.dataSource = self
        friendsView.inviteButton.button.addTarget(self, action: #selector(inviteTapped), for: .touchUpInside)
    }
    
    @objc private func inviteTapped() {
        let nickname = friendsView.friendsNicknameTextField.textField.text ?? ""
        guard !nickname.isEmpty else {
            showAlert(title: "Error", message: "Please enter a nickname")
            return
        }
        
        pendingInvites.append(nickname)
        friendsView.pendingInvitesTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingInvites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = pendingInvites[indexPath.row]
        return cell
    }
}
