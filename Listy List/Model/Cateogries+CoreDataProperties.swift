//
//  Cateogries+CoreDataProperties.swift
//  Listy List
//
//  Created by Tomas Sanni on 7/25/22.
//
//

import Foundation
import CoreData


extension Cateogries {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cateogries> {
        return NSFetchRequest<Cateogries>(entityName: "Cateogries")
    }

    @NSManaged public var name: String?
    @NSManaged public var time: Date?
    @NSManaged public var color: String?
    @NSManaged public var pinned: Bool
    @NSManaged public var item: NSSet?
    
    
    
    
    public var wrappedName: String {
        name ?? "Unknown name"
    }
    
    public var wrappedTime: Date {
        time ?? Date.now
    }
    
    public var wrappedPinned: Bool {
        pinned
    }
    
    public var itemArray: [Item] {
        let set = item as? Set<Item> ?? []
        
        return set.sorted { a, b in
            a.wrappedItemTime > b.wrappedItemTime

        }
    }

}

// MARK: Generated accessors for item
extension Cateogries {

    @objc(addItemObject:)
    @NSManaged public func addToItem(_ value: Item)

    @objc(removeItemObject:)
    @NSManaged public func removeFromItem(_ value: Item)

    @objc(addItem:)
    @NSManaged public func addToItem(_ values: NSSet)

    @objc(removeItem:)
    @NSManaged public func removeFromItem(_ values: NSSet)

}

extension Cateogries : Identifiable {

}
