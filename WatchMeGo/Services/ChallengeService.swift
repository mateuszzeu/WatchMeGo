//
//  ChallengeService.swift
//  WatchMeGo
//
//  Created by Liza on 07/08/2025.
//

import FirebaseFirestore

final class ChallengeService {
    private static var db: Firestore { Firestore.firestore() }
    private static var challenges: CollectionReference { db.collection("challenges") }

    static func createChallenge(_ challenge: Challenge) async throws {
        let data = try Firestore.Encoder().encode(challenge)
        try await challenges.document(challenge.id).setData(data)
    }

    static func fetchChallenges(ids: [String]) async throws -> [Challenge] {
        guard !ids.isEmpty else { return [] }
        let snap = try await challenges
            .whereField(FieldPath.documentID(), in: ids)
            .getDocuments()
        let decoder = Firestore.Decoder()
        return snap.documents.compactMap { try? decoder.decode(Challenge.self, from: $0.data()) }
    }

    static func fetchByPair(pairID: String) async throws -> [Challenge] {
        let snap = try await challenges
            .whereField("pairID", isEqualTo: pairID)
            .getDocuments()
        let decoder = Firestore.Decoder()
        return snap.documents.compactMap { try? decoder.decode(Challenge.self, from: $0.data()) }
    }

    static func setStatus(challengeID: String, to status: Challenge.Status) async throws {
        try await challenges.document(challengeID)
            .setData(["status": status.rawValue], merge: true)
    }

    static func markActive(pairID: String) async throws {
        let snap = try await challenges
            .whereField("pairID", isEqualTo: pairID)
            .limit(to: 1)
            .getDocuments()
        if let doc = snap.documents.first {
            try await doc.reference.setData(["status": Challenge.Status.active.rawValue], merge: true)
        }
    }

    static func deleteChallenge(challengeID: String) async throws {
        try await challenges.document(challengeID).delete()
    }
}
