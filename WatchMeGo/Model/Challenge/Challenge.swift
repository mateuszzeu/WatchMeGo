//
//  Challenge.swift
//  WatchMeGo
//
//  Created by Liza on 07/08/2025.
//

import Foundation

struct Challenge: Identifiable, Codable {
    struct MetricInfo: Codable, Identifiable {
        let metric: Metric
        let target: Int?
        var id: Metric { metric }
    }

    enum Status: String, Codable {
        case pending
        case active
        case completed
    }

    let id: String
    let pairID: String

    var name: String
    var senderID: String
    var senderName: String
    var receiverID: String
    var receiverName: String
    var mode: Mode
    var metrics: [MetricInfo]
    var duration: Int
    var prize: String?
    var status: Status
    var createdAt: Date
}
