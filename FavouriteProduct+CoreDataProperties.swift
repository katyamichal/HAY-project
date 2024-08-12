//
//  FavouriteProduct+CoreDataProperties.swift
//  Project
//
//  Created by Catarina Polakowsky on 12.08.2024.
//
//

import Foundation
import CoreData


extension FavouriteProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteProduct> {
        return NSFetchRequest<FavouriteProduct>(entityName: "FavouriteProduct")
    }

    @NSManaged public var colour: String
    @NSManaged public var identifier: Int32
    @NSManaged public var image: String
    @NSManaged public var imageCollection: Data?
    @NSManaged public var material: String
    @NSManaged public var name: String
    @NSManaged public var price: Int64
    @NSManaged public var productDescription: String
    @NSManaged public var size: String
}

extension FavouriteProduct : Identifiable {

}
