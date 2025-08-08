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
    private static var users: CollectionReference { db.collection("users") }

    static func createChallenge(_ challenge: Challenge) async throws {
        try await challenges.document(challenge.id).setData(from: challenge)

        try await users.document(challenge.senderID).updateData([
            "sentChallenges": FieldValue.arrayUnion([challenge.id])
        ])
        try await users.document(challenge.receiverID).updateData([
            "pendingChallenges": FieldValue.arrayUnion([challenge.id])
        ])
    }

    static func fetchChallenges(ids: [String]) async throws -> [Challenge] {
        guard !ids.isEmpty else { return [] }
        let snap = try await challenges.whereField(FieldPath.documentID(), in: ids).getDocuments()
        let decoder = Firestore.Decoder()
        return snap.documents.compactMap { try? decoder.decode(Challenge.self, from: $0.data()) }
    }
}
