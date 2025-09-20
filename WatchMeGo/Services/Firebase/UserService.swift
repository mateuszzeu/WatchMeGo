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
    static var friendshipsCollection: CollectionReference { database.collection("friendships") }
    
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
    
    static func fetchUserByEmail(_ email: String) async throws -> AppUser? {
        let snapshot = try await usersCollection.whereField("email", isEqualTo: email).limit(to: 1).getDocuments()
        guard let document = snapshot.documents.first else { return nil }
        let decoder = Firestore.Decoder()
        return try? decoder.decode(AppUser.self, from: document.data())
    }
    
    static func fetchUserName(byID userID: String) async throws -> String {
        let user = try await fetchUser(byID: userID)
        return user.name
    }
    
    static func sendInvite(from senderId: String, to recipientEmail: String) async throws {
        guard let recipient = try await fetchUserByEmail(recipientEmail) else {
            throw AppError.userNotFound
        }
        
        if senderId == recipient.id {
            throw AppError.selfInvite
        }
        
        let friendshipId = [senderId, recipient.id].sorted().joined(separator: "_")
        let existingFriendship = try await friendshipsCollection.document(friendshipId).getDocument()
        
        if existingFriendship.exists {
            let decoder = Firestore.Decoder()
            guard let friendship = try? decoder.decode(Friendship.self, from: existingFriendship.data()!) else {
                throw AppError.userNotFound
            }
            
            switch friendship.status {
            case .accepted:
                throw AppError.alreadyFriends
            case .pending:
                throw AppError.inviteAlreadySent
            case .rejected:
                try await friendshipsCollection.document(friendshipId).updateData([
                    "status": Friendship.FriendshipStatus.pending.rawValue,
                    "requesterId": senderId
                ])
                return
            }
        }
        
        let friendship = Friendship(
            id: friendshipId,
            users: [senderId, recipient.id].sorted(),
            requesterId: senderId,
            status: .pending
        )
        
        let encodedFriendship = try Firestore.Encoder().encode(friendship)
        try await friendshipsCollection.document(friendshipId).setData(encodedFriendship)
    }
    
    static func fetchPendingInvites(for userId: String) async throws -> [Friendship] {
        let snapshot = try await friendshipsCollection
            .whereField("users", arrayContains: userId)
            .whereField("status", isEqualTo: Friendship.FriendshipStatus.pending.rawValue)
            .whereField("requesterId", isNotEqualTo: userId)
            .getDocuments()
        
        let decoder = Firestore.Decoder()
        return snapshot.documents.compactMap { try? decoder.decode(Friendship.self, from: $0.data()) }
    }
    
    static func fetchFriends(for userId: String) async throws -> [AppUser] {
        let snapshot = try await friendshipsCollection
            .whereField("users", arrayContains: userId)
            .whereField("status", isEqualTo: Friendship.FriendshipStatus.accepted.rawValue)
            .getDocuments()
        
        let decoder = Firestore.Decoder()
        let friendships = snapshot.documents.compactMap { try? decoder.decode(Friendship.self, from: $0.data()) }
        
        let friendIds = friendships.compactMap { friendship in
            friendship.users.first { $0 != userId }
        }
        
        guard !friendIds.isEmpty else { return [] }
        
        let friendsSnapshot = try await usersCollection
            .whereField(FieldPath.documentID(), in: friendIds)
            .getDocuments()
        
        return friendsSnapshot.documents.compactMap { document in
            try? Firestore.Decoder().decode(AppUser.self, from: document.data())
        }
    }
    
    static func acceptInvite(friendshipId: String) async throws {
        try await friendshipsCollection.document(friendshipId).updateData([
            "status": Friendship.FriendshipStatus.accepted.rawValue
        ])
    }
    
    static func declineInvite(friendshipId: String) async throws {
        try await friendshipsCollection.document(friendshipId).delete()
    }
    
    static func resetPassword() async throws {
        guard let user = Auth.auth().currentUser, let email = user.email else {
            throw AppError.userNotFound
        }
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    static func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AppError.userNotFound
        }
        
        let userFriendships = try await friendshipsCollection
            .whereField("users", arrayContains: user.uid)
            .getDocuments()
        
        for document in userFriendships.documents {
            try await document.reference.delete()
        }
        
        try await usersCollection.document(user.uid).delete()
        try await user.delete()
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
