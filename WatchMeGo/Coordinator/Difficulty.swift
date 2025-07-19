//
//  Difficulty.swift
//  WatchMeGo
//
//  Created by Liza on 19/07/2025.
//

enum Difficulty: String, CaseIterable, Identifiable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    var id: String { rawValue }

    var caloriesGoal: Int {
        switch self {
        case .easy: return 250
        case .medium: return 500
        case .hard: return 800
        }
    }

    var exerciseGoal: Int {
        switch self {
        case .easy: return 10
        case .medium: return 30
        case .hard: return 60
        }
    }

    var standGoal: Int {
        switch self {
        case .easy: return 6
        case .medium: return 12
        case .hard: return 16
        }
    }
}
