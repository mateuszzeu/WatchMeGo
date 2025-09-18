//
//  CompetitionService.swift
//  WatchMeGo
//
//  Created by MAT on 16/09/2025.
//
import FirebaseFirestore
import FirebaseAuth

final class CompetitionService {
    static var database: Firestore { Firestore.firestore() }
    static var competitionsCollection: CollectionReference { database.collection("competitions") }
    
    static func createCompetition(
        between users: [String],
        initiatorId: String,
        metrics: [Metric],
        duration: Int,
        prize: String? = nil,
        name: String
    ) async throws -> Competition {
        let competitionId = UUID().uuidString
        let dateString = DateFormatter.dayFormatter.string(from: Date())
        var initialProgress: [String: [String: DailyProgress]] = [:]

        if let progress = try await ProgressService.fetchProgress(for: initiatorId, date: dateString) {
            initialProgress[initiatorId] = [dateString: progress]
        }

        let competition = Competition(
            id: competitionId,
            name: name,
            users: users.sorted(),
            initiatorId: initiatorId,
            status: .pending,
            startDate: Date(),
            endDate: nil,
            metrics: metrics,
            duration: duration,
            prize: prize,
            progress: initialProgress
        )
        
        let encodedCompetition = try Firestore.Encoder().encode(competition)
        try await competitionsCollection.document(competitionId).setData(encodedCompetition)
        return competition
    }
    
    static func acceptCompetition(competitionId: String) async throws {
        guard let acceptingUser = Auth.auth().currentUser else { return }
        
        let dateString = DateFormatter.dayFormatter.string(from: Date())
        var dataToUpdate: [String: Any] = [
            "status": Competition.CompetitionStatus.active.rawValue,
            "startDate": FieldValue.serverTimestamp()
        ]

        if let progress = try await ProgressService.fetchProgress(for: acceptingUser.uid, date: dateString) {
            let progressData: [String: Any] = [
                "calories": progress.calories,
                "exerciseMinutes": progress.exerciseMinutes,
                "standHours": progress.standHours
            ]
            dataToUpdate["progress.\(acceptingUser.uid).\(dateString)"] = progressData
        }

        try await competitionsCollection.document(competitionId).updateData(dataToUpdate)
    }
    
    static func declineCompetition(competitionId: String) async throws {
        try await competitionsCollection.document(competitionId).updateData([
            "status": Competition.CompetitionStatus.cancelled.rawValue
        ])
    }

    static func fetchActiveCompetitions(for userId: String) async throws -> [Competition] {
        let snapshot = try await competitionsCollection
            .whereField("users", arrayContains: userId)
            .whereField("status", isEqualTo: Competition.CompetitionStatus.active.rawValue)
            .getDocuments()
        
        return try snapshot.documents.compactMap { try $0.data(as: Competition.self) }
    }
    
    static func fetchPendingCompetitions(for userId: String) async throws -> [Competition] {
        let snapshot = try await competitionsCollection
            .whereField("users", arrayContains: userId)
            .whereField("status", isEqualTo: Competition.CompetitionStatus.pending.rawValue)
            .whereField("initiatorId", isNotEqualTo: userId)
            .getDocuments()
        
        return try snapshot.documents.compactMap { try $0.data(as: Competition.self) }
    }
    
    static func fetchCompetition(byId competitionId: String) async throws -> Competition? {
        try? await competitionsCollection.document(competitionId).getDocument(as: Competition.self)
    }
    
    static func endCompetition(competitionId: String) async throws {
        try await competitionsCollection.document(competitionId).updateData([
            "status": Competition.CompetitionStatus.completed.rawValue,
            "endDate": FieldValue.serverTimestamp()
        ])
    }
    
    static func deleteCompetition(competitionId: String) async throws {
        try await competitionsCollection.document(competitionId).delete()
    }
    
    static func getCompetitionPartner(for userId: String, in competition: Competition) -> String? {
        return competition.users.first { $0 != userId }
    }
    
    static func updateCompetitionProgress(
        competitionId: String,
        userId: String,
        date: String,
        progress: [String: Any]
    ) async throws {
        try await competitionsCollection.document(competitionId).updateData([
            "progress.\(userId).\(date)": progress
        ])
    }

    static func listenForCompetitionUpdates(competitionId: String, completion: @escaping (Competition?) -> Void) -> ListenerRegistration {
        let listener = competitionsCollection.document(competitionId).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                completion(nil)
                return
            }
            completion(try? document.data(as: Competition.self))
        }
        return listener
    }
}
