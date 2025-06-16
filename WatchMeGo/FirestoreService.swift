//
//  FirestoreService.swift
//  WatchMeGo
//
//  Created by Liza on 10/06/2025.
//

import FirebaseFirestore

class FirestoreService {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    
    func saveProgress(for nickname: String, steps: Int, stand: Int, calories: Int) {
        let userProgress: [String: Any] = [
            "nickname": nickname,
            "steps": steps,
            "stand": stand,
            "calories": calories,
            "timestamp": Timestamp(date: Date())
        ]
        db.collection("usersProgress").document(nickname).setData(userProgress)
    }
    
    func fetchProgress(for nickname: String, completion: @escaping (Int, Int, Int) -> Void) {
        db.collection("usersProgress").document(nickname).getDocument { snapshot, error in
            guard let data = snapshot?.data(),
                  let steps = data["steps"] as? Int,
                  let stand = data["stand"] as? Int,
                  let calories = data["calories"] as? Int else {
                return
            }
            completion(steps, stand, calories)
        }
    }
}
