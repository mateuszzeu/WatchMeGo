//
//  UserService.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//

import FirebaseFirestore
import FirebaseAuth

final class UserService {
    static var database: Firestore { Firestore.firestore() }
    static var usersCollection: CollectionReference { database.collection("users") }
    
    static func createUser(_ user: AppUser) async throws {
        let encodedUserData = try Firestore.Encoder().encode(user)
        try await usersCollection.document(user.id).setData(encodedUserData)
    }
    
    static func fetchUser(byID userID: String) async throws -> AppUser {
        let snapshot = try await usersCollection.document(userID).getDocument()
        let decoder = Firestore.Decoder()
        guard let data = snapshot.data(),
              let decodedUser = try? decoder.decode(AppUser.self, from: data) else {
            throw AppError.userNotFound
        }
        return decodedUser
    }
    
    static func fetchUsers(byUsernames usernames: [String]) async throws -> [AppUser] {
        guard !usernames.isEmpty else { return [] }
        let snapshot = try await usersCollection.whereField("name", in: usernames).getDocuments()
        let decoder = Firestore.Decoder()
        return snapshot.documents.compactMap { try? decoder.decode(AppUser.self, from: $0.data()) }
    }
    
    static func fetchFriends(for user: AppUser) async throws -> [AppUser] {
        try await fetchUsers(byUsernames: user.friends)
    }
    
    static func saveProgress(forUserID userID: String, date: String, progress: DailyProgress) async throws {
        let encodedProgressData = try Firestore.Encoder().encode(progress)
        let historyKey = "history.\(date)"
        try await usersCollection.document(userID).setData([
            "currentProgress": encodedProgressData,
            historyKey: encodedProgressData
        ], merge: true)
    }
    
    static func sendInvite(from sender: AppUser, toUsername recipientUsername: String) async throws {
        if recipientUsername == sender.name { throw AppError.selfInvite }
        if sender.friends.contains(recipientUsername) { throw AppError.alreadyFriends }
        if sender.sentInvites.contains(recipientUsername) { throw AppError.inviteAlreadySent }
        
        let snapshot = try await usersCollection.whereField("name", isEqualTo: recipientUsername).limit(to: 1).getDocuments()
        guard let recipientDocument = snapshot.documents.first else { throw AppError.userNotFound }
        
        let senderReference = usersCollection.document(sender.id)
        let recipientReference = recipientDocument.reference
        
        try await senderReference.updateData(["sentInvites": FieldValue.arrayUnion([recipientUsername])])
        try await recipientReference.updateData(["pendingInvites": FieldValue.arrayUnion([sender.name])])
    }
    
    static func acceptInvite(my currentUser: AppUser, from otherUser: AppUser) async throws {
        let currentUserReference = usersCollection.document(currentUser.id)
        let otherUserReference = usersCollection.document(otherUser.id)
        
        try await currentUserReference.updateData([
            "pendingInvites": FieldValue.arrayRemove([otherUser.name]),
            "friends": FieldValue.arrayUnion([otherUser.name])
        ])
        
        try await otherUserReference.updateData([
            "sentInvites": FieldValue.arrayRemove([currentUser.name]),
            "friends": FieldValue.arrayUnion([currentUser.name])
        ])
    }
    
    static func declineInvite(my currentUser: AppUser, from otherUser: AppUser) async throws {
        let currentUserReference = usersCollection.document(currentUser.id)
        let otherUserReference = usersCollection.document(otherUser.id)
        
        try await currentUserReference.updateData([
            "pendingInvites": FieldValue.arrayRemove([otherUser.name])
        ])
        
        try await otherUserReference.updateData([
            "sentInvites": FieldValue.arrayRemove([currentUser.name])
        ])
    }
    
    static func sendCompetitionInvite(fromUserID userID: String, toFriendID friendID: String) async throws {
        let senderDocument = try await usersCollection.document(userID).getDocument()
        let recipientDocument = try await usersCollection.document(friendID).getDocument()
        
        guard let senderData = senderDocument.data(), let recipientData = recipientDocument.data() else {
            throw AppError.userNotFound
        }
        
        let senderStatus = senderData["competitionStatus"] as? String ?? "none"
        let recipientStatus = recipientData["competitionStatus"] as? String ?? "none"
        if senderStatus == "active" || recipientStatus == "active" {
            throw AppError.alreadyInCompetition
        }
        
        try await usersCollection.document(userID).updateData([
            "pendingCompetitionWith": friendID,
            "competitionStatus": "pendingSent"
        ])
        try await usersCollection.document(friendID).updateData([
            "pendingCompetitionWith": userID,
            "competitionStatus": "pendingReceived"
        ])
    }
    
    static func acceptCompetitionInvite(userID: String, friendID: String) async throws {
        try await usersCollection.document(userID).updateData([
            "activeCompetitionWith": friendID,
            "pendingCompetitionWith": FieldValue.delete(),
            "competitionStatus": "active"
        ])
        try await usersCollection.document(friendID).updateData([
            "activeCompetitionWith": userID,
            "pendingCompetitionWith": FieldValue.delete(),
            "competitionStatus": "active"
        ])
    }
    
    static func declineCompetitionInvite(userID: String, friendID: String) async throws {
        try await usersCollection.document(userID).updateData([
            "pendingCompetitionWith": FieldValue.delete(),
            "competitionStatus": "none"
        ])
        try await usersCollection.document(friendID).updateData([
            "pendingCompetitionWith": FieldValue.delete(),
            "competitionStatus": "none"
        ])
    }
    
    static func endCompetition(userID: String, friendID: String) async throws {
        try await usersCollection.document(userID).updateData([
            "activeCompetitionWith": FieldValue.delete(),
            "competitionStatus": "none"
        ])
        try await usersCollection.document(friendID).updateData([
            "activeCompetitionWith": FieldValue.delete(),
            "competitionStatus": "none"
        ])
    }
    
    static func logout() throws {
        try Auth.auth().signOut()
    }
    
    static func setResultMessage(forUserID userID: String, message: String) async throws {
        try await usersCollection.document(userID).setData([
            "lastChallengeResult": message,
            "lastChallengeResultAt": FieldValue.serverTimestamp()
        ], merge: true)
    }

    static func consumeResultMessage(forUserID userID: String) async throws -> String? {
        let userReference = usersCollection.document(userID)
        let snapshot = try await userReference.getDocument()
        guard let data = snapshot.data(),
              let message = data["lastChallengeResult"] as? String,
              !message.isEmpty else { return nil }
        try await userReference.updateData([
            "lastChallengeResult": FieldValue.delete(),
            "lastChallengeResultAt": FieldValue.delete()
        ])
        return message
    }
}
