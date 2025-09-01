//
//  DesignSystem.swift
//  WatchMeGo
//
//  Created by Liza on 03/08/2025.
//

import SwiftUI

enum DesignSystem {
    enum Colors {
        static let primary = Color("TextPrimary")
        static let secondary = Color("SecondaryText")
        static let background = Color("BackgroundPrimary")
        static let surface = Color("Surface")
        static let accent = Color("AccentColor")
        static let error = Color("Error")
        static let move = Color("ActivityMove")
        static let exercise = Color("ActivityExercise")
        static let stand = Color("ActivityStand")
    }

    enum Fonts {
        static let title = Font.system(.largeTitle, design: .rounded).weight(.bold)
        static let headline = Font.system(.headline, design: .rounded)
        static let body = Font.system(.body, design: .rounded)
        static let footnote = Font.system(.footnote, design: .rounded)
        static let caption = Font.system(.caption, design: .rounded)
    }

    enum Spacing {
        static let xs: CGFloat = 4
        static let s: CGFloat = 8
        static let m: CGFloat = 16
        static let l: CGFloat = 24
    }

    enum Radius {
        static let s: CGFloat = 8
        static let m: CGFloat = 12
        static let l: CGFloat = 20
    }
}
