//
//  ErrorHandler.swift
//  WatchMeGo
//
//  Created by Liza on 21/07/2025.
//

import SwiftUI

@MainActor
@Observable
final class ErrorHandler {
    static let shared = ErrorHandler()

    var errorMessage: String?
    var showError = false

    func handle(_ error: Error) {
        if let appError = error as? AppError {
            errorMessage = appError.localizedDescription
        } else {
            errorMessage = "Unknown error: \(error.localizedDescription)"
        }
        showError = true

        Task {
            try? await Task.sleep(nanoseconds: 3000000000)
            showError = false
            errorMessage = nil
        }
    }
}
