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
        let ref = challenges.document(challengeID)
        let snap = try await ref.getDocument()
        guard let data = snap.data() else { return }
        let senderID = data["senderID"] as? String
        let receiverID = data["receiverID"] as? String
        try await ref.delete()
        if let s = senderID {
            try await users.document(s).updateData([
                "sentChallenges": FieldValue.arrayRemove([challengeID]),
                "pendingChallenges": FieldValue.arrayRemove([challengeID])
            ])
        }
        if let r = receiverID {
            try await users.document(r).updateData([
                "pendingChallenges": FieldValue.arrayRemove([challengeID]),
                "sentChallenges": FieldValue.arrayRemove([challengeID])
            ])
        }
    }
}

