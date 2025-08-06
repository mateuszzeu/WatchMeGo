//
//  Mode.swift
//  WatchMeGo
//
//  Created by Liza on 06/08/2025.
//

import Foundation

enum Mode: String, CaseIterable, Identifiable {
    case coop = "COOP"
    case versus = "VERSUS"

    var id: String { rawValue }
    var title: String { rawValue }
}
