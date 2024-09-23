//
//  Basket+CoreDataProperties.swift
//  Project
//
//  Created by Catarina Polakowsky on 23.09.2024.
//
//

import Foundation
import CoreData


extension Basket {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Basket> {
        return NSFetchRequest<Basket>(entityName: "Basket")
    }

    @NSManaged public var productId: Int16
    @NSManaged public var count: Int16

}

extension Basket : Identifiable {

}
