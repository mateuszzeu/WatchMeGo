//
//  Competition.swift
//  WatchMeGo
//
//  Created by MAT on 16/09/2025.
//
import Foundation

struct Competition: Identifiable, Codable {
    let id: String
    let name: String
    let users: [String]
    let initiatorId: String
    var status: CompetitionStatus
    let startDate: Date
    var endDate: Date?
    let metrics: [Metric]
    let duration: Int
    let prize: String?
    
    var progress: [String: [String: DailyProgress]]?
    
    enum CompetitionStatus: String, Codable {
        case pending, active, completed, cancelled
    }
}
