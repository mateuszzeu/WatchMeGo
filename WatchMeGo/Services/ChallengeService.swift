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

    static func deleteChallenge(challengeID: String) async throws {
        try await challengesCollection.document(challengeID).delete()
    }
}
