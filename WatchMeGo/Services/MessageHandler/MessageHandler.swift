//
//  MessageHandler.swift
//  WatchMeGo
//
//  Created by Liza on 03/08/2025.
//

import SwiftUI

@MainActor
@Observable
final class MessageHandler {
    static let shared = MessageHandler()

    var message: String?
    var messageType: MessageType = .error
    var showMessage = false
    
    enum MessageType {
        case error
        case success
        
        var backgroundColor: Color {
            switch self {
            case .error:
                return .red
            case .success:
                return .green
            }
        }
    }

    func showError(_ error: Error) {
        if let appError = error as? AppError {
            message = appError.localizedDescription
        } else {
            message = "Unknown error: \(error.localizedDescription)"
        }
        messageType = .error
        showMessage = true
        scheduleHide()
    }
    
    func showSuccess(_ message: String) {
        self.message = message
        messageType = .success
        showMessage = true
        scheduleHide()
    }

    func clearMessage() {
        showMessage = false
        message = nil
    }
    
    private func scheduleHide() {
        Task {
            try? await Task.sleep(nanoseconds: 3000000000)
            showMessage = false
            message = nil
        }
    }
}
