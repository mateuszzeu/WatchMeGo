//
//  UserService.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//

import FirebaseFirestore
import FirebaseAuth

final class UserService {
    private static var db: Firestore { Firestore.firestore() }
    private static var users: CollectionReference { db.collection("users") }
    
    static func createUser(_ user: AppUser) throws {
        try users.document(user.id).setData(from: user)
    }
    
    static func fetchUser(id: String) async throws -> AppUser {
        let snapshot = try await users.document(id).getDocument()
        guard let user = try? snapshot.data(as: AppUser.self) else {
            throw AppError.userNotFound
        }
        return user
    }
    
    static func fetchUsers(usernames: [String]) async throws -> [AppUser] {
        guard !usernames.isEmpty else { return [] }
        let snap = try await users.whereField("name", in: usernames).getDocuments()
        return snap.documents.compactMap { try? $0.data(as: AppUser.self) }
    }
    
    static func saveProgress(for userID: String, progress: DailyProgress) async throws {
        let data = try Firestore.Encoder().encode(progress)
        try await users.document(userID).setData(["currentProgress": data], merge: true)
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
    
    static func updateCompetition(userID: String, with friendName: String?) async throws {
        let update: [String: Any] = ["activeCompetitionWith": friendName as Any]
        try await users.document(userID).updateData(update)
    }
}
