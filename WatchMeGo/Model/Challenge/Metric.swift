//
//  Metric.swift
//  WatchMeGo
//
//  Created by Liza on 06/08/2025.
//

import Foundation

enum Metric: String, CaseIterable, Identifiable, Codable {
    case calories
    case exerciseMinutes
    case standHours

    var id: String { rawValue }

    var title: String {
        switch self {
        case .calories: return "Calories Burned"
        case .exerciseMinutes: return "Exercise Minutes"
        case .standHours: return "Stand Hours"
        }
    }

    var iconName: String {
        switch self {
        case .calories: return "flame.fill"
        case .exerciseMinutes: return "figure.run"
        case .standHours: return "clock"
        }
    }
}
