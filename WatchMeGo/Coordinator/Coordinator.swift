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
        case splash
        case login
        case register
        case main
    }
    
    var screen: Screen = .splash
    var currentUser: AppUser?
    var selectedDifficulty: Difficulty = .medium
    
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
    
    func refreshCurrentUser() async throws {
        guard let userID = currentUser?.id else { return }
        currentUser = try await UserService.fetchUser(byID: userID)
    }
    
    func updateCurrentUser(_ user: AppUser) {
        currentUser = user
    }
}
