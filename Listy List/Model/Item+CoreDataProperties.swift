//
//  Item+CoreDataProperties.swift
//  Listy List
//
//  Created by Tomas Sanni on 7/25/22.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var name: String?
    @NSManaged public var completed: Bool
    @NSManaged public var time: Date?
    @NSManaged public var color: String?
    @NSManaged public var pinned: Bool
    @NSManaged public var origin: Cateogries?
    
    public var wrappedItemName: String {
        name ?? "Unknown item name"
    }
    
    public var wrappedCompletedItem: Bool {
        completed
    }
    
    public var wrappedItemTime: Date {
        time ?? Date.now
    }

}

extension Item : Identifiable {

}
