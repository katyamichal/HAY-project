//
//  FavouriteProduct+CoreDataProperties.swift
//  Project
//
//  Created by Catarina Polakowsky on 27.08.2024.
//
//

import Foundation
import CoreData


extension FavouriteProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteProduct> {
        return NSFetchRequest<FavouriteProduct>(entityName: "FavouriteProduct")
    }

    @NSManaged public var identifier: Int32
    @NSManaged public var image: String
    @NSManaged public var name: String
    @NSManaged public var price: Int32
    @NSManaged public var endpoint: String
    @NSManaged public var itemIdentifier: Int16
}

extension FavouriteProduct : Identifiable {

}
