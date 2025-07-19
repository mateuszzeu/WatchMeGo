//
//  UserService.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//

import FirebaseFirestore
import FirebaseAuth

final class UserService {
    static func createUser(_ user: AppUser) throws {
        let db = Firestore.firestore()
        try db.collection("users").document(user.id).setData(from: user)
    }

    static func fetchUser(id: String, completion: @escaping (Result<AppUser, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(id).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = try? snapshot?.data(as: AppUser.self) {
                completion(.success(data))
            }
        }
    }
}
