//
//  DateFormatter.swift
//  WatchMeGo
//
//  Created by MAT on 08/09/2025.
//

import Foundation

extension DateFormatter {
    static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current
        return formatter
    }()
}
