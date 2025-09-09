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
        static let progressBar = Color("ProgressBarColor")
        static let error = Color("Error")
        static let move = Color("ActivityMove")
        static let exercise = Color("ActivityExercise")
        static let stand = Color("ActivityStand")
        static let borderFriends = Color("BorderFriends")
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
