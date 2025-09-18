//
//  ProgressService.swift
//  WatchMeGo
//
//  Created by MAT on 16/09/2025.
//

import FirebaseFirestore
import FirebaseAuth

final class ProgressService {
    static var database: Firestore { Firestore.firestore() }
    static var progressCollection: CollectionReference { database.collection("progress") }
    
    static func saveProgress(for userId: String, date: String, progress: DailyProgress) async throws {
        let progressId = "\(userId)_\(date)"
        let progressData: [String: Any] = [
            "userId": userId,
            "date": date,
            "calories": progress.calories,
            "exerciseMinutes": progress.exerciseMinutes,
            "standHours": progress.standHours,
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        try await progressCollection.document(progressId).setData(progressData, merge: true)
        
        await updateActiveCompetitions(userId: userId, date: date, progress: progress)
    }
    
    private static func updateActiveCompetitions(userId: String, date: String, progress: DailyProgress) async {
        do {
            let activeCompetitions = try await CompetitionService.fetchActiveCompetitions(for: userId)
            
            for competition in activeCompetitions {
                let progressData: [String: Any] = [
                    "calories": progress.calories,
                    "exerciseMinutes": progress.exerciseMinutes,
                    "standHours": progress.standHours
                ]
                
                try await CompetitionService.updateCompetitionProgress(
                    competitionId: competition.id,
                    userId: userId,
                    date: date,
                    progress: progressData
                )
            }
        } catch {
            
        }
    }
    
    static func fetchProgress(for userId: String, date: String) async throws -> DailyProgress? {
        let progressId = "\(userId)_\(date)"
        let snapshot = try await progressCollection.document(progressId).getDocument()
        
        guard let data = snapshot.data() else { return nil }
        
        return DailyProgress(
            calories: data["calories"] as? Int ?? 0,
            exerciseMinutes: data["exerciseMinutes"] as? Int ?? 0,
            standHours: data["standHours"] as? Int ?? 0
        )
    }
    
    static func fetchProgressHistory(for userId: String, dates: [String]) async throws -> [String: DailyProgress] {
        let progressIds = dates.map { "\(userId)_\($0)" }
        
        guard !progressIds.isEmpty else { return [:] }
        
        let snapshot = try await progressCollection
            .whereField(FieldPath.documentID(), in: progressIds)
            .getDocuments()
        
        var history: [String: DailyProgress] = [:]
        
        for document in snapshot.documents {
            let data = document.data()
            guard let date = data["date"] as? String else { continue }
            
            history[date] = DailyProgress(
                calories: data["calories"] as? Int ?? 0,
                exerciseMinutes: data["exerciseMinutes"] as? Int ?? 0,
                standHours: data["standHours"] as? Int ?? 0
            )
        }
        
        return history
    }
}
