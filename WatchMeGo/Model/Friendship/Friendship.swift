//
//  Friendship.swift
//  WatchMeGo
//
//  Created by MAT on 16/09/2025.
//
import Foundation

struct Friendship: Identifiable, Codable {
    var id: String
    let users: [String]
    let requesterId: String
    var status: FriendshipStatus

    enum FriendshipStatus: String, Codable {
        case pending
        case accepted
        case rejected
    }
}
