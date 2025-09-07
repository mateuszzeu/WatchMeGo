//
//  SettingsViewModel.swift
//  WatchMeGo
//
//  Created by Liza on 2025-08-18.
//

import Foundation

@MainActor
@Observable
final class SettingsViewModel {
    private let coordinator: Coordinator
    
    var currentUser: AppUser? {
        coordinator.currentUser
    }
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    var selectedDifficulty: Difficulty {
            get { coordinator.selectedDifficulty }
            set { coordinator.selectedDifficulty = newValue }
        }
    
    func logout(coordinator: Coordinator) {
        do {
            try UserService.logout()
            coordinator.logout()
        } catch {
            MessageHandler.shared.showError(error)
        }
    }
    
    func resetPassword() {
        Task {
            do {
                try await UserService.resetPassword()
                MessageHandler.shared.showSuccess("Password reset email sent! Check your inbox.")
            } catch {
                MessageHandler.shared.showError(error)
            }
        }
    }
    
    func deleteAccount(coordinator: Coordinator) {
        Task {
            do {
                try await UserService.deleteAccount()
                coordinator.logout()
                MessageHandler.shared.showSuccess("Account deleted successfully.")
            } catch {
                MessageHandler.shared.showError(error)
            }
        }
    }
}



