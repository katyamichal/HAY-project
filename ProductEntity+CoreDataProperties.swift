//
//  ProductEntity+CoreDataProperties.swift
//  Project
//
//  Created by Catarina Polakowsky on 12.08.2024.
//
//

import Foundation
import CoreData


extension ProductEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductEntity> {
        return NSFetchRequest<ProductEntity>(entityName: "ProductEntity")
    }

    @NSManaged public var colour: String
    @NSManaged public var id: Int32
    @NSManaged public var image: String
    @NSManaged public var imageCollection: Data?
    @NSManaged public var material: String
    @NSManaged public var name: String
    @NSManaged public var price: Int64
    @NSManaged public var productDescription: String
    @NSManaged public var size: String
    @NSManaged public var isFavourite: Bool
    @NSManaged public var inBasketCount: Int16

}

extension ProductEntity : Identifiable {

}
