//
//  ProductCDO.swift
//  Project
//
//  Created by Catarina Polakowsky on 12.08.2024.
//

import Foundation

struct ProductCDO: Equatable, Entity {
    let id: Int
    let productName: String
    let description: String
    let price: Int
    let image: String
    let imageCollection: [String]
    let material: String
    let size: String
    let colour: String
    var typeName: EntityType
}

extension ProductCDO {
    init(with product: Product, type: EntityType) {
        self.id = product.id
        self.productName = product.productName
        self.description = product.description
        self.price = product.price
        self.image = product.image
        self.imageCollection = product.imageCollection
        self.material = product.material
        self.size = product.size
        self.colour = product.colour
        self.typeName = type
    }
}
