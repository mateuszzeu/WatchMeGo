//
//  DailyChallengeResult.swift
//  WatchMeGo
//
//  Created by Liza on 21/06/2025.
//

import Foundation

struct DailyChallengeResult {
    let date: String
    let steps: Int
    let stand: Int
    let calories: Int
    let userChallengeMet: Bool
    let allySteps: Int?
    let allyStand: Int?
    let allyCalories: Int?
    let allyChallengeMet: Bool?
    let bothChallengeMet: Bool
}
