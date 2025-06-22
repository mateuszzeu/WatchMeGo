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
    
    func saveDailyChallengeResult(
        date: String,
        userNickname: String,
        steps: Int,
        stand: Int,
        calories: Int,
        userChallengeMet: Bool,
        allyNickname: String?,
        allySteps: Int?,
        allyStand: Int?,
        allyCalories: Int?,
        allyChallengeMet: Bool?
    ) {
        var data: [String: Any] = [
            "date": date,
            "userNickname": userNickname,
            "steps": steps,
            "stand": stand,
            "calories": calories,
            "userChallengeMet": userChallengeMet
        ]
        
        var bothChallengeMet = false
        
        if let allyNickname = allyNickname {
            data["allyNickname"] = allyNickname
            data["allySteps"] = allySteps ?? 0
            data["allyStand"] = allyStand ?? 0
            data["allyCalories"] = allyCalories ?? 0
            data["allyChallengeMet"] = allyChallengeMet ?? false
            
            bothChallengeMet = userChallengeMet && (allyChallengeMet ?? false)
        }
        
        data["bothChallengeMet"] = bothChallengeMet
        
        let documentId = "\(userNickname)_\(date)"
        db.collection("dailyChallengeResults").document(documentId).setData(data)
    }
    
    func fetchAllyStreaks(for userNickname: String, completion: @escaping ([String: Int]) -> Void) {
        db.collection("dailyChallengeResults")
            .whereField("userNickname", isEqualTo: userNickname)
            .whereField("bothChallengeMet", isEqualTo: true)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    completion([:])
                    return
                }
                
                var streaks: [String: Int] = [:]
                
                for document in documents {
                    if let ally = document.data()["allyNickname"] as? String {
                        streaks[ally, default: 0] += 1
                    }
                }
                
                completion(streaks)
            }
    }
}
