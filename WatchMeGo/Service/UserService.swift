//
//  UserService.swift
//  WatchMeGo
//
//  Created by Liza on 02/06/2025.
//

import UIKit

struct UserService {
    
    static func createUser(email: String, nickname: String, password: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let user = User(context: context)
        user.email = email
        user.nickname = nickname
        user.password = password
        
        do {
            try context.save()
        }
        catch {
            context.rollback()
            fatalError("Core Data saving error: \(error.localizedDescription)")
        }
    }
    
    static func authenticateUser(nickname: String, password: String) -> Bool {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = User.fetchRequest()
        
        request.predicate = NSPredicate(format: "nickname == %@ AND password == %@", nickname, password)
        
        do {
            let user = try context.fetch(request)
            
            if let _ = user.first {
                return true
            } else {
                return false
            }
        } catch {
            context.rollback()
            fatalError("Core Data fetching error: \(error.localizedDescription)")
        }
    }
}
