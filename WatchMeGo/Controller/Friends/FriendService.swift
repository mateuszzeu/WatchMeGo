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
        guard let currentUser = UserDefaults.standard.string(forKey: "loggedInNickname") else { return [] }
        
        let context = CoreDataManager.shared.context
        let request = Friend.fetchRequest()
        request.predicate = NSPredicate(format: "owner == %@ AND status == %@", currentUser, "pending")
        
        do {
            return try context.fetch(request)
        } catch {
            context.rollback()
            return []
        }
    }
    
    func fetchAcceptedFriends() -> [Friend] {
        guard let currentUser = UserDefaults.standard.string(forKey: "loggedInNickname") else { return [] }
        
        let context = CoreDataManager.shared.context
        let request = Friend.fetchRequest()
        request.predicate = NSPredicate(format: "owner == %@ AND status == %@", currentUser, "accepted")
        
        do {
            return try context.fetch(request)
        } catch {
            context.rollback()
            return[]
        }
    }
    
    func fetchCurrentRival() -> Friend? {
        guard let currentUser = UserDefaults.standard.string(forKey: "loggedInNickname") else { return nil }
        
        let context = CoreDataManager.shared.context
        let request = Friend.fetchRequest()
        request.predicate = NSPredicate(format: "owner == %@ AND status == %@ AND isRival == YES", currentUser, "accepted")
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            context.rollback()
            return nil
        }
    }
}

