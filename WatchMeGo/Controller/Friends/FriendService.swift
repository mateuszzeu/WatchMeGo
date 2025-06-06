//
//  FriendService.swift
//  WatchMeGo
//
//  Created by Liza on 05/06/2025.
//

import UIKit
import CoreData

final class FriendService {
    static let shared = FriendService()

    func fetchPendingInvites() -> [Friend] {
        guard let currentUser = UserDefaults.standard.string(forKey: "loggedInNickname") else { return [] } // replace to if let
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = Friend.fetchRequest()
        request.predicate = NSPredicate(format: "owner == %@ AND status == %@", currentUser, "pending")
        
        do {
            let invites = try context.fetch(request)
            return invites
        } catch {
            context.rollback()
            print("Error fetching invites: \(error)")
            return []
        }
    }
}

