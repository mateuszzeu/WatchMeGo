//
//  AppError.swift
//  WatchMeGo
//
//  Created by Liza on 21/07/2025.
//

import SwiftUI

enum AppError: Error, LocalizedError {
    case emptyField(fieldName: String)
    case userNotFound
    case selfInvite
    case alreadyFriends
    case inviteAlreadySent
    case alreadyInCompetition
    case usernameTaken
    
    var errorDescription: String? {
        switch self {
        case .emptyField(let fieldName):
            return "\(fieldName) field cannot be empty."
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
