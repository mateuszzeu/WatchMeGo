//
//  Coordinator.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//
import SwiftUI

@MainActor
@Observable
final class Coordinator {
    
    enum Screen {
        case login
        case register
        case main
    }
    
    var screen: Screen = .login
    var currentUser: AppUser?
    
    func login(_ user: AppUser) {
        currentUser = user
        screen = .main
    }
    
    func logout() {
        currentUser = nil
        screen = .login
    }
    
    func navigate(to screen: Screen) {
        self.screen = screen
    }
}
