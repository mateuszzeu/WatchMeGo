//
//  Friend+CoreDataProperties.swift
//  WatchMeGo
//
//  Created by Liza on 04/06/2025.
//
//

import Foundation
import CoreData


extension Friend : Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Friend> {
        return NSFetchRequest<Friend>(entityName: "Friend")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var isAlly: Bool
    @NSManaged public var nickname: String?
    @NSManaged public var status: String?
    @NSManaged public var owner: String?

}
