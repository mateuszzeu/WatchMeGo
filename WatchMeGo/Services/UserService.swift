//
//  UserService.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//

import FirebaseFirestore
import FirebaseAuth

final class UserService {
    static var db: Firestore { Firestore.firestore() }
    static var users: CollectionReference { db.collection("users") }
    
    static func createUser(_ user: AppUser) async throws {
        let data = try Firestore.Encoder().encode(user)
        try await users.document(user.id).setData(data)
    }
    
    static func fetchUser(id: String) async throws -> AppUser {
        let snapshot = try await users.document(id).getDocument()
        let decoder = Firestore.Decoder()
        guard let data = snapshot.data(),
              let user = try? decoder.decode(AppUser.self, from: data) else {
            throw AppError.userNotFound
        }
        return user
    }
    
    static func fetchUsers(usernames: [String]) async throws -> [AppUser] {
        guard !usernames.isEmpty else { return [] }
        let snap = try await users.whereField("name", in: usernames).getDocuments()
        let decoder = Firestore.Decoder()
        return snap.documents.compactMap { try? decoder.decode(AppUser.self, from: $0.data()) }
    }
    
    static func fetchFriends(for user: AppUser) async throws -> [AppUser] {
        try await fetchUsers(usernames: user.friends)
    }
    
    static func saveProgress(for userID: String, date: String, progress: DailyProgress) async throws {
        let data = try Firestore.Encoder().encode(progress)
        let historyKey = "history.\(date)"
        try await users.document(userID).setData([
            "currentProgress": data,
            historyKey: data
        ], merge: true)
    }
    
    static func sendInvite(from me: AppUser, toUsername: String) async throws {
        if toUsername == me.name { throw AppError.selfInvite }
        if me.friends.contains(toUsername) { throw AppError.alreadyFriends }
        if me.sentInvites.contains(toUsername) { throw AppError.inviteAlreadySent }
        
        let snap = try await users.whereField("name", isEqualTo: toUsername).limit(to: 1).getDocuments()
        guard let doc = snap.documents.first else { throw AppError.userNotFound }
        
        let meRef = users.document(me.id)
        let themRef = doc.reference
        
        try await meRef.updateData(["sentInvites": FieldValue.arrayUnion([toUsername])])
        try await themRef.updateData(["pendingInvites": FieldValue.arrayUnion([me.name])])
    }
    
    static func acceptInvite(my me: AppUser, from other: AppUser) async throws {
        let meRef = users.document(me.id)
        let themRef = users.document(other.id)
        
        try await meRef.updateData([
            "pendingInvites": FieldValue.arrayRemove([other.name]),
            "friends": FieldValue.arrayUnion([other.name])
        ])
        
        try await themRef.updateData([
            "sentInvites": FieldValue.arrayRemove([me.name]),
            "friends": FieldValue.arrayUnion([me.name])
        ])
    }
    
    static func declineInvite(my me: AppUser, from other: AppUser) async throws {
        let meRef = users.document(me.id)
        let themRef = users.document(other.id)
        
        try await meRef.updateData([
            "pendingInvites": FieldValue.arrayRemove([other.name])
        ])
        
        try await themRef.updateData([
            "sentInvites": FieldValue.arrayRemove([me.name])
        ])
    }
    
    static func updateCompetition(userID: String, friendID: String?) async throws {
        try await users.document(userID).updateData(["activeCompetitionWith": friendID as Any])
    }
    
    static func sendCompetitionInvite(from userID: String, to friendID: String) async throws {
        let fromDoc = try await users.document(userID).getDocument()
        let toDoc = try await users.document(friendID).getDocument()
        
        guard let fromData = fromDoc.data(), let toData = toDoc.data() else {
            throw AppError.userNotFound
        }
        
        let fromStatus = fromData["competitionStatus"] as? String ?? "none"
        let toStatus = toData["competitionStatus"] as? String ?? "none"
        if fromStatus == "active" || toStatus == "active" {
            throw AppError.alreadyInCompetition
        }
        
        try await users.document(userID).updateData([
            "pendingCompetitionWith": friendID,
            "competitionStatus": "pendingSent"
        ])
        try await users.document(friendID).updateData([
            "pendingCompetitionWith": userID,
            "competitionStatus": "pendingReceived"
        ])
    }
    
    static func acceptCompetitionInvite(userID: String, friendID: String) async throws {
        try await users.document(userID).updateData([
            "activeCompetitionWith": friendID,
            "pendingCompetitionWith": FieldValue.delete(),
            "competitionStatus": "active"
        ])
        try await users.document(friendID).updateData([
            "activeCompetitionWith": userID,
            "pendingCompetitionWith": FieldValue.delete(),
            "competitionStatus": "active"
        ])
        
        let pairID = [userID, friendID].sorted().joined(separator: "_")
        try await ChallengeService.markActive(pairID: pairID)
    }
    
    static func declineCompetitionInvite(userID: String, friendID: String) async throws {
        try await users.document(userID).updateData([
            "pendingCompetitionWith": FieldValue.delete(),
            "competitionStatus": "none"
        ])
        try await users.document(friendID).updateData([
            "pendingCompetitionWith": FieldValue.delete(),
            "competitionStatus": "none"
        ])
    }
    
    static func endCompetition(userID: String, friendID: String) async throws {
        try await users.document(userID).updateData([
            "activeCompetitionWith": FieldValue.delete(),
            "competitionStatus": "none"
        ])
        try await users.document(friendID).updateData([
            "activeCompetitionWith": FieldValue.delete(),
            "competitionStatus": "none"
        ])
    }
    
    static func logout() throws {
        try Auth.auth().signOut()
    }
    
    static func setResultMessage(userID: String, message: String) async throws {
        try await users.document(userID).setData([
            "lastChallengeResult": message,
            "lastChallengeResultAt": FieldValue.serverTimestamp()
        ], merge: true)
    }

    static func consumeResultMessage(userID: String) async throws -> String? {
        let ref = users.document(userID)
        let snap = try await ref.getDocument()
        guard let data = snap.data(),
              let msg = data["lastChallengeResult"] as? String,
              !msg.isEmpty else { return nil }
        try await ref.updateData([
            "lastChallengeResult": FieldValue.delete(),
            "lastChallengeResultAt": FieldValue.delete()
        ])
        return msg
    }
}
