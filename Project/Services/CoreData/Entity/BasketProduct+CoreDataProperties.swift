//
//  BasketProduct+CoreDataProperties.swift
//  Project
//
//  Created by Catarina Polakowsky on 20.09.2024.
//
//

import Foundation
import CoreData


extension BasketProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BasketProduct> {
        return NSFetchRequest<BasketProduct>(entityName: "BasketProduct")
    }

    @NSManaged public var count: Int16
    @NSManaged public var endpoint: String
    @NSManaged public var identifier: Int16
    @NSManaged public var itemIdentifier: Int16
    @NSManaged public var image: String
    @NSManaged public var name: String
    @NSManaged public var price: Int32

}

extension BasketProduct : Identifiable {

}
