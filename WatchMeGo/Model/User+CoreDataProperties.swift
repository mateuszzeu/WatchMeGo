//
//  User+CoreDataProperties.swift
//  WatchMeGo
//
//  Created by Liza on 02/06/2025.
//

import Foundation
import CoreData

extension User {

    @NSManaged public var email: String
    @NSManaged public var nickname: String
    @NSManaged public var password: String
}
