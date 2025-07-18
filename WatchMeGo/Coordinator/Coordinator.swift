//
//  Coordinator.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//
import SwiftUI

@Observable
final class Coordinator {
    var screen: Screen = .login
    var currentUser: AppUser?

    enum Screen {
        case login
        case register
        case main
    }

    func login(_ user: AppUser) {
        currentUser = user
        screen = .main
    }

    func logout() {
        currentUser = nil
        screen = .login
    }

    func showRegister() {
        screen = .register
    }

    func showLogin() {
        screen = .login
    }
}
