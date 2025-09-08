//
//  Badge.swift
//  WatchMeGo
//
//  Created by MAT on 08/09/2025.
//
import Foundation
import SwiftUI

struct Badge: Identifiable, Codable {
    let id: String
    let date: String
    let level: BadgeLevel
    let earnedAt: Date
    
    init(level: BadgeLevel, date: String = DateFormatter.dayFormatter.string(from: Date())) {
        self.id = "\(date)_\(level.rawValue)"
        self.date = date
        self.level = level
        self.earnedAt = Date()
    }
}

enum BadgeLevel: String, CaseIterable, Codable {
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"
    
    var color: Color {
        switch self {
        case .easy: return .green
        case .medium: return .blue
        case .hard: return .purple
        }
    }
    
    var displayName: String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }
}
