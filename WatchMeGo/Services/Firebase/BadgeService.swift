//
//  BadgeService.swift
//  WatchMeGo
//
//  Created by MAT on 16/09/2025.
//

import FirebaseFirestore
import FirebaseAuth

final class BadgeService {
    static var database: Firestore { Firestore.firestore() }
    static var badgesCollection: CollectionReference { database.collection("badges") }
    
    static func determineBadgeLevel(for progress: DailyProgress) -> BadgeLevel? {
        let easyMet = progress.calories >= Difficulty.easy.caloriesGoal &&
                     progress.exerciseMinutes >= Difficulty.easy.exerciseMinutesGoal &&
                     progress.standHours >= Difficulty.easy.standHoursGoal
        
        let mediumMet = progress.calories >= Difficulty.medium.caloriesGoal &&
                       progress.exerciseMinutes >= Difficulty.medium.exerciseMinutesGoal &&
                       progress.standHours >= Difficulty.medium.standHoursGoal
        
        let hardMet = progress.calories >= Difficulty.hard.caloriesGoal &&
                     progress.exerciseMinutes >= Difficulty.hard.exerciseMinutesGoal &&
                     progress.standHours >= Difficulty.hard.standHoursGoal
        
        if hardMet { return .hard }
        if mediumMet { return .medium }
        if easyMet { return .easy }
        
        return nil
    }
    
    static func checkAndAwardBadge(for userId: String, progress: DailyProgress, date: String) async throws -> Badge? {
        guard let newBadgeLevel = determineBadgeLevel(for: progress) else { return nil }
        
        let badgeId = "\(userId)_\(date)_\(newBadgeLevel.rawValue)"
        let existingBadge = try await badgesCollection.document(badgeId).getDocument()
        
        if existingBadge.exists {
            return nil
        }
        
        let newBadge = Badge(level: newBadgeLevel, date: date)
        let badgeData: [String: Any] = [
            "userId": userId,
            "date": date,
            "level": newBadgeLevel.rawValue,
            "earnedAt": FieldValue.serverTimestamp()
        ]
        
        try await badgesCollection.document(badgeId).setData(badgeData)
        return newBadge
    }
    
    static func getBadgeCounts(for userId: String) async throws -> (easy: Int, medium: Int, hard: Int) {
        let snapshot = try await badgesCollection
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        
        var easyCount = 0
        var mediumCount = 0
        var hardCount = 0
        
        for document in snapshot.documents {
            guard let level = document.data()["level"] as? String else { continue }
            
            switch level {
            case "easy": easyCount += 1
            case "medium": mediumCount += 1
            case "hard": hardCount += 1
            default: break
            }
        }
        
        return (easy: easyCount, medium: mediumCount, hard: hardCount)
    }
}
