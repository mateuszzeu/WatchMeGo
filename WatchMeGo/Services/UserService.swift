//
//  UserService.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//

import FirebaseFirestore
import FirebaseAuth

final class UserService {
    private static var db: Firestore {
        Firestore.firestore()
    }
    
    static func createUser(_ user: AppUser) throws {
        try db.collection("users").document(user.id).setData(from: user)
    }
    
    static func fetchUser(id: String, completion: @escaping (Result<AppUser, Error>) -> Void) {
        db.collection("users").document(id).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = try? snapshot?.data(as: AppUser.self) {
                completion(.success(user))
            } else {
                completion(.failure(NSError(domain: "UserService", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found or data invalid"])))
            }
        }
    }
    
    static func saveProgress(for userID: String, progress: DailyProgress, completion: ((Error?) -> Void)? = nil) {
        do {
            let encoded = try Firestore.Encoder().encode(progress)
            db.collection("users")
                .document(userID)
                .setData(["currentProgress": encoded], merge: true) {
                    error in completion?(error)
                }
        } catch {
            completion?(error)
        }
    }
}
