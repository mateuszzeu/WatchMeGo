//
//  ChallengeService.swift
//  WatchMeGo
//
//  Created by Liza on 07/08/2025.
//

import FirebaseFirestore

final class ChallengeService {
    private static var database: Firestore { Firestore.firestore() }
    private static var challengesCollection: CollectionReference { database.collection("challenges") }

    static func createChallenge(_ challenge: Challenge) async throws {
        let encodedChallengeData = try Firestore.Encoder().encode(challenge)
        try await challengesCollection.document(challenge.id).setData(encodedChallengeData)
    }

    static func fetchChallenges(challengeIDs: [String]) async throws -> [Challenge] {
        guard !challengeIDs.isEmpty else { return [] }
        let snapshot = try await challengesCollection
            .whereField(FieldPath.documentID(), in: challengeIDs)
            .getDocuments()
        let decoder = Firestore.Decoder()
        return snapshot.documents.compactMap { try? decoder.decode(Challenge.self, from: $0.data()) }
    }

    static func fetchChallengesByPair(pairID: String) async throws -> [Challenge] {
        let snapshot = try await challengesCollection
            .whereField("pairID", isEqualTo: pairID)
            .getDocuments()
        let decoder = Firestore.Decoder()
        return snapshot.documents.compactMap { try? decoder.decode(Challenge.self, from: $0.data()) }
    }

    static func setChallengeStatus(challengeID: String, to status: Challenge.Status) async throws {
        try await challengesCollection.document(challengeID)
            .setData(["status": status.rawValue], merge: true)
    }

    static func markChallengeActive(pairID: String) async throws {
        let snapshot = try await challengesCollection
            .whereField("pairID", isEqualTo: pairID)
            .limit(to: 1)
            .getDocuments()
        if let document = snapshot.documents.first {
            try await document.reference.setData(["status": Challenge.Status.active.rawValue], merge: true)
        }
    }

    static func deleteChallenge(challengeID: String) async throws {
        try await challengesCollection.document(challengeID).delete()
    }
}
