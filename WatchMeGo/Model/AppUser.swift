//
//  AppUser.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//
import Foundation

struct AppUser: Identifiable, Codable {
    let id: String   
    var name: String
    var friends: [String]
    var createdAt: Date
}
