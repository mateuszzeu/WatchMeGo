//
//  FriendsViewController.swift
//  WatchMeGo
//
//  Created by Liza on 04/06/2025.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let friendsView = FriendsView()
    private var pendingInvites: [Friend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = friendsView
        
        friendsView.pendingInvitesTable.delegate = self
        friendsView.pendingInvitesTable.dataSource = self
        friendsView.pendingInvitesTable.register(InviteCell.self, forCellReuseIdentifier: "InviteCell")
        friendsView.inviteButton.button.addTarget(self, action: #selector(inviteTapped), for: .touchUpInside)
        
        loadPendingInvites()
    }
    
    @objc private func inviteTapped() {
        guard
            let receiverNickname = friendsView.friendsNicknameTextField.textField.text,
            !receiverNickname.isEmpty,
            let senderNickname = UserDefaults.standard.string(forKey: "loggedInNickname")
        else {
            showAlert(title: "Error", message: "Please enter a nickname")
            return
        }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let invite = Friend(context: context)
        invite.id = UUID()
        invite.nickname = senderNickname
        invite.owner = receiverNickname
        invite.status = "pending"
        
        do {
            try context.save()
            showAlert(title: "Success", message: "Invite sent to \(receiverNickname)")
        } catch {
            context.rollback()
            showAlert(title: "Error", message: "Failed to send invite")
        }
        
        loadPendingInvites()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingInvites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InviteCell", for: indexPath) as? InviteCell else {
            return UITableViewCell()
        }
        let invite = pendingInvites[indexPath.row]
        cell.nicknameLabel.text = "From: \(invite.nickname ?? "Unknown")"
        return cell
    }
    
    private func loadPendingInvites() {
        pendingInvites = FriendService.shared.fetchPendingInvites()
        friendsView.pendingInvitesTable.reloadData()
    }
}
