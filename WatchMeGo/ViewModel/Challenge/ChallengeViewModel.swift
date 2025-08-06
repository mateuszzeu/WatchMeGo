//
//  ChallengeViewModel.swift
//  WatchMeGo
//
//  Created by Liza on 06/08/2025.
//
import Foundation
import SwiftUI

@MainActor
@Observable
final class ChallengeViewModel {
    private(set) var currentUser: AppUser

    var selectedFriend = ""
    var name = ""
    var mode: Mode = .coop
    var metrics: [MetricSelection] = Metric.allCases.map { MetricSelection(metric: $0) }
    var duration = 1
    var prize = ""

    var availableFriends: [String] {
        currentUser.friends.filter { $0 != currentUser.activeCompetitionWith }
    }

    init(currentUser: AppUser) {
        self.currentUser = currentUser
    }

    var canSend: Bool {
        guard !selectedFriend.isEmpty,
              !name.isEmpty,
              metrics.contains(where: { $0.isSelected }),
              (1...7).contains(duration) else { return false }

        if mode == .coop {
            for metric in metrics where metric.isSelected {
                if Int(metric.target) == nil { return false }
            }
        }
        return true
    }
}
