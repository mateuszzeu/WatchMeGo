//
//  WatchMeGoApp.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//

import SwiftUI
import FirebaseCore

@main
struct WatchMeGoApp: App {

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .preferredColorScheme(.dark)
        }
    }
}

