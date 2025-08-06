//
//  MetricSelection.swift
//  WatchMeGo
//
//  Created by Liza on 06/08/2025.
//

import Foundation

struct MetricSelection: Identifiable {
    let metric: Metric
    var isSelected = false
    var target = ""
    var id: Metric { metric }
}
