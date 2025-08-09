//
//  AppError.swift
//  WatchMeGo
//
//  Created by Liza on 21/07/2025.
//

import SwiftUI

enum AppError: Error, LocalizedError {
    case invalidEmail
    case passwordTooShort
    case passwordsDoNotMatch
    case emptyField(fieldName: String)
    case invalidInput(fieldName: String)
    case authenticationError
    case networkError
    case databaseError
    case unknownError
    case userNotFound
    case selfInvite
    case alreadyFriends
    case inviteAlreadySent
    case alreadyInCompetition
    case usernameTaken
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Invalid email address."
        case .passwordTooShort:
            return "Password must be at least 6 characters long."
        case .passwordsDoNotMatch:
            return "Passwords do not match."
        case .emptyField(let fieldName):
            return "\(fieldName) field cannot be empty."
        case .invalidInput(let fieldName):
            return "\(fieldName) must be a valid number."
        case .authenticationError:
            return "Login failed. Please check your credentials."
        case .networkError:
            return "No internet connection."
        case .databaseError:
            return "Database connection error."
        case .unknownError:
            return "An unexpected error occurred."
        case .userNotFound:
            return "User not found."
        case .selfInvite:
            return "You cannot invite yourself."
        case .alreadyFriends:
            return "Already friends."
        case .inviteAlreadySent:
            return "Invite already sent."
        case .alreadyInCompetition:
            return "User is already in a competition."
        case .usernameTaken:
            return "This username is already taken."
        }
    }
}
