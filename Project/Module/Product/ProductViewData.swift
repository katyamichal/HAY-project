//
//  ProductViewData.swift
//  Project
//
//  Created by Catarina Polakowsky on 16.07.2024.
//

import Foundation

struct ProductViewData {
    let id: Int
    let productName: String
    let image: String
    let imageCollection: [String]
    let link: String
    let description: String
    let material: String
    let colour: String
    let size: String
    let price: Int
//    var isFavourite: Bool = false
//    var inBasket: Bool = false
   // var typeName: EntityType
}

extension ProductViewData: IProductCDO {
//    var type: EntityType {
//        .
//    }
    
    init(product: Product) {
        self.id = product.id
        self.productName = product.productName
        self.image = product.image
        self.imageCollection = product.imageCollection
        self.description = product.description
        self.material = product.material
        self.colour = product.colour
        self.size = product.size
        self.price = product.price
        self.link = "https://www.hay.dk"
    }
}
