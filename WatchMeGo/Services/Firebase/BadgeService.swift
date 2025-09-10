//
//  BadgeService.swift
//  WatchMeGo
//
//  Created by MAT on 08/09/2025.
//
import Foundation
import FirebaseFirestore

final class BadgeService {
    static var database: Firestore { Firestore.firestore() }
    static var usersCollection: CollectionReference { database.collection("users") }
    
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
    
    static func checkAndAwardBadge(for userID: String, progress: DailyProgress, date: String, existingBadges: [Badge]) async throws -> Badge? {
        guard isBadgeAwardTime() else { return nil }
        guard let badgeLevel = determineBadgeLevel(for: progress) else { return nil }
        
        let hasBadgeForDate = existingBadges.contains { $0.date == date }
        guard !hasBadgeForDate else { return nil }
        
        let newBadge = Badge(level: badgeLevel, date: date)
        
        try await usersCollection.document(userID).updateData([
            "badges": FieldValue.arrayUnion([try Firestore.Encoder().encode(newBadge)])
        ])
        
        return newBadge
    }
    
    private static func isBadgeAwardTime() -> Bool {
        let calendar = Calendar.current
        let now = Date()
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        
        return hour == 23 && minute >= 59
    }
    
    static func getBadgeCounts(for user: AppUser) -> (easy: Int, medium: Int, hard: Int) {
        let easyCount = user.badges.filter { $0.level == .easy }.count
        let mediumCount = user.badges.filter { $0.level == .medium }.count
        let hardCount = user.badges.filter { $0.level == .hard }.count
        return (easy: easyCount, medium: mediumCount, hard: hardCount)
    }
}


