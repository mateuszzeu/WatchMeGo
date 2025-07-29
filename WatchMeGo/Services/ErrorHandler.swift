//
//  ErrorHandler.swift
//  WatchMeGo
//
//  Created by Liza on 21/07/2025.
//

import SwiftUI

@Observable
final class ErrorHandler {
    static let shared = ErrorHandler()
    
    var errorMessage: String?
    var showError: Bool = false
    
    func handle(_ error: Error) {
        if let appError = error as? AppError {
            errorMessage = appError.localizedDescription
        } else {
            errorMessage = "Unknown error: \(error.localizedDescription)"
        }
        showError = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.showError = false
            self?.errorMessage = nil
        }
    }
}

