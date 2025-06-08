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
    private var acceptedFriends: [Friend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = friendsView
        
        friendsView.pendingInvitesTable.delegate = self
        friendsView.pendingInvitesTable.dataSource = self
        friendsView.pendingInvitesTable.register(InviteCell.self, forCellReuseIdentifier: "InviteCell")
        friendsView.inviteButton.button.addTarget(self, action: #selector(inviteTapped), for: .touchUpInside)
        
        loadPendingInvites()
        
        friendsView.acceptedFriendsTable.delegate = self
        friendsView.acceptedFriendsTable.dataSource = self
        friendsView.acceptedFriendsTable.register(UITableViewCell.self, forCellReuseIdentifier: "FriendCell")
        
        loadAcceptedFriends()
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
    
    @objc private func acceptInvite(_ sender: UIButton) {
        let index = sender.tag
        let invite = pendingInvites[index]
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        invite.status = "accepted"
        
        do {
            try context.save()
            loadPendingInvites()
            loadAcceptedFriends()
        } catch {
            context.rollback()
            showAlert(title: "Error", message: "Failed to accept invite")
        }
    }
    
    @objc private func rejectInvite(_ sender: UIButton) {
        let index = sender.tag
        let invite = pendingInvites[index]
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        invite.status = "rejected"
        
        do {
            try context.save()
            loadPendingInvites()
        } catch {
            context.rollback()
            showAlert(title: "Error", message: "Failed to reject invite")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == friendsView.pendingInvitesTable {
            return pendingInvites.count
        } else if tableView == friendsView.acceptedFriendsTable {
            return acceptedFriends.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == friendsView.pendingInvitesTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InviteCell", for: indexPath) as? InviteCell else {
                return UITableViewCell()
            }
            let invite = pendingInvites[indexPath.row]
            cell.nicknameLabel.text = "From: \(invite.nickname ?? "Unknown")"
            
            cell.acceptButton.tag = indexPath.row
            cell.rejectButton.tag = indexPath.row
            
            cell.acceptButton.addTarget(self, action: #selector(acceptInvite(_:)), for: .touchUpInside)
            cell.rejectButton.addTarget(self, action: #selector(rejectInvite(_:)), for: .touchUpInside)
            
            return cell
            
        } else if tableView == friendsView.acceptedFriendsTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath)
            let friend = acceptedFriends[indexPath.row]
            cell.textLabel?.text = friend.nickname ?? "Unknown"
            return cell
        }
        
        return UITableViewCell()
    }
    
    private func loadPendingInvites() {
        pendingInvites = FriendService.shared.fetchPendingInvites()
        acceptedFriends = FriendService.shared.fetchAcceptedFriends()
        friendsView.pendingInvitesTable.reloadData()
        friendsView.acceptedFriendsTable.reloadData()
    }
    
    private func loadAcceptedFriends() {
        acceptedFriends = FriendService.shared.fetchAcceptedFriends()
        friendsView.acceptedFriendsTable.reloadData()
    }
}
