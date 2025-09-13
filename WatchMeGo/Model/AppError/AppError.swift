//
//  AppError.swift
//  WatchMeGo
//
//  Created by Liza on 21/07/2025.
//

import SwiftUI

enum AppError: Error, LocalizedError {
    case emptyField(fieldName: String)
    case invalidEmail
    case passwordTooShort
    case usernameTooShort
    case userNotFound
    case selfInvite
    case alreadyFriends
    case inviteAlreadySent
    case alreadyInCompetition
    case usernameTaken
    case accountDeletionFailed
    
    var errorDescription: String? {
        switch self {
        case .emptyField(let fieldName):
            return "\(fieldName) field cannot be empty."
        case .invalidEmail:
            return "Please enter a valid email address."
        case .passwordTooShort:
            return "Password must be at least 6 characters long."
        case .usernameTooShort:
            return "Username must be at least 3 characters long."
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
        case .accountDeletionFailed:
            return "Failed to delete account. Please try again."
        }
    }
}
