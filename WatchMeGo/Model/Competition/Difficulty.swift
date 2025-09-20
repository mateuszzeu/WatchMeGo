//
//  Untitled.swift
//  WatchMeGo
//
//  Created by MAT on 07/09/2025.
//

import Foundation

enum Difficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var caloriesGoal: Int {
        switch self {
        case .easy: return 400
        case .medium: return 800
        case .hard: return 1200
        }
    }
    
    var exerciseMinutesGoal: Int {
        switch self {
        case .easy: return 30
        case .medium: return 60
        case .hard: return 120
        }
    }
    
    var standHoursGoal: Int {
        switch self {
        case .easy: return 7
        case .medium: return 10
        case .hard: return 14
        }
    }
}
