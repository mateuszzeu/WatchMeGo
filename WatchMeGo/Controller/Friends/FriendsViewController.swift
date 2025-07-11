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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        friendsView.pendingInvitesTable.delegate = self
        friendsView.pendingInvitesTable.dataSource = self
        friendsView.pendingInvitesTable.register(InviteCell.self, forCellReuseIdentifier: "InviteCell")
        friendsView.inviteButton.button.addTarget(self, action: #selector(inviteTapped), for: .touchUpInside)
        
        loadPendingInvites()
        
        friendsView.acceptedFriendsTable.delegate = self
        friendsView.acceptedFriendsTable.dataSource = self
        friendsView.acceptedFriendsTable.register(FriendCell.self, forCellReuseIdentifier: "FriendCell")
        
        loadAcceptedFriends()
        
        friendsView.logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
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
        
        if receiverNickname == senderNickname {
            showAlert(title: "Invalid", message: "You cannot invite yourself.")
            clearTextField(friendsView.friendsNicknameTextField.textField)
            return
        }
        
        if acceptedFriends.contains(where: { $0.nickname == receiverNickname }) {
            showAlert(title: "Already Friends", message: "\(receiverNickname) is already your friend.")
            clearTextField(friendsView.friendsNicknameTextField.textField)
            return
        }
        
        let context = CoreDataManager.shared.context
        let invite = Friend(context: context)
        invite.id = UUID()
        invite.nickname = senderNickname
        invite.owner = receiverNickname
        invite.status = "pending"
        
        do {
            try context.save()
            showAlert(title: "Success", message: "Invite sent to \(receiverNickname)")
            clearTextField(friendsView.friendsNicknameTextField.textField)
        } catch {
            context.rollback()
            showAlert(title: "Error", message: "Failed to send invite")
        }
        loadPendingInvites()
    }
    
    @objc private func acceptInvite(_ sender: UIButton) {
        let index = sender.tag
        let invite = pendingInvites[index]
        
        let context = CoreDataManager.shared.context
        
        invite.status = "accepted"
        
        let invitedFriend = Friend(context: context)
        invitedFriend.id = UUID()
        invitedFriend.nickname = invite.owner
        invitedFriend.owner = invite.nickname
        invitedFriend.status = "accepted"
        
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
        
        let context = CoreDataManager.shared.context
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
            
            cell.configure(
                with: invite.nickname ?? "Unknown",
                index: indexPath.row,
                target: self,
                acceptSelector: #selector(acceptInvite(_:)),
                rejectSelector: #selector(rejectInvite(_:))
            )
            
            return cell
            
        } else if tableView == friendsView.acceptedFriendsTable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell else {
                return UITableViewCell()
            }
            
            let friend = acceptedFriends[indexPath.row]
            let isAlly = friend.isAlly
            
            cell.configure(with: friend.nickname ?? "Unknown", isAlly: isAlly)
            
            cell.onCompeteTapped = { [weak self] in
                self?.showAlert(
                    title: isAlly ? "Stop competing with \(friend.nickname ?? "")?" : "Compete with \(friend.nickname ?? "")?",
                    message: isAlly ? "Do you want to stop the competition?" : "Do you want to start a competition?",
                    okTitle: isAlly ? "Stop" : "Start",
                    cancelTitle: "Cancel",
                    okHandler: {
                        self?.toggleAllyStatus(for: friend)
                    }
                )
            }
            
            cell.onDeleteTapped = { [weak self] in
                self?.showAlert(
                    title: "Delete \(friend.nickname ?? "friend")?",
                    message: "Are you sure you want to remove this user from your friends list?",
                    okTitle: "Delete",
                    cancelTitle: "Cancel"
                ) {
                    self?.deleteFriend(friend)
                }
            }
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
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func showCompeteAlert(for friend: Friend) {
        showAlert(
            title: "Compete with \(friend.nickname ?? "this friend")?",
            message: "Are you sure you want to start a competition?",
            okHandler: { print("Starting competition with \(friend.nickname ?? "unknown")") }
        )
    }
    
    private func toggleAllyStatus(for selectedFriend: Friend) {
        let context = CoreDataManager.shared.context
        
        for friend in acceptedFriends {
            friend.isAlly = (friend == selectedFriend) ? !friend.isAlly  : false
        }
        
        do {
            try context.save()
            loadAcceptedFriends()
            
            NotificationCenter.default.post(name: .allyStatusChanged, object: nil)
            
        } catch {
            context.rollback()
            showAlert(title: "Error", message: "Failed to update ally status")
        }
    }
    
    private func deleteFriend(_ friend: Friend) {
        let context = CoreDataManager.shared.context
        context.delete(friend)
        
        if let currentUser = UserDefaults.standard.string(forKey: "loggedInNickname"),
           let otherNickname = friend.nickname {
            
            let mirrorRequest = Friend.fetchRequest()
            mirrorRequest.predicate = NSPredicate(
                format: "owner == %@ AND nickname == %@ AND status == %@", otherNickname, currentUser, "accepted"
            )
            
            if let mirror = try? context.fetch(mirrorRequest).first {
                context.delete(mirror)
            }
        }
        
        do {
            try context.save()
            if friend.isAlly {
                NotificationCenter.default.post(name: .allyStatusChanged, object: nil)
            }
            loadAcceptedFriends()
        } catch {
            context.rollback()
            showAlert(title: "Error", message: "Failed to delete friend.")
        }
    }
    
    @objc private func logoutTapped() {
        UserDefaults.standard.removeObject(forKey: "loggedInNickname")
        let loginVC = LoginViewController()
        let nav = UINavigationController(rootViewController: loginVC)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
}
