//
//  HayProduct+CoreDataProperties.swift
//  Project
//
//  Created by Catarina Polakowsky on 23.09.2024.
//
//

import Foundation
import CoreData


extension HayProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HayProduct> {
        return NSFetchRequest<HayProduct>(entityName: "HayProduct")
    }

    @NSManaged public var endpoint: String
    @NSManaged public var identifier: Int16
    @NSManaged public var image: String
    @NSManaged public var itemIdentifier: Int16
    @NSManaged public var name: String
    @NSManaged public var price: Int32
    @NSManaged public var isFavourite: Bool

}

extension HayProduct : Identifiable {

}
