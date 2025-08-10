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
    var createdAt: Date
    
    var friends: [String]
    var pendingInvites: [String]
    var sentInvites: [String]
    
    var currentProgress: DailyProgress?
    var history: [String: DailyProgress]
    
    var activeCompetitionWith: String?
    var pendingCompetitionWith: String?
    var competitionStatus = "none"
}

