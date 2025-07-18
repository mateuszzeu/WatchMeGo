//
//  AppUser.swift
//  WatchMeGo
//
//  Created by Liza on 18/07/2025.
//
import Foundation

struct AppUser: Identifiable, Codable {
    let id: String
    let email: String
    var name: String
}
