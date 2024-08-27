//
//  ProductViewData.swift
//  Project
//
//  Created by Catarina Polakowsky on 16.07.2024.
//

import Foundation

struct ProductViewData {
    let endpoint: ProductEndpoint
    let itemIdentifier: Int
    let productId: Int
    let productName: String
    let image: String
    let imageCollection: [String]
    let link: String
    let description: String
    let material: String
    let colour: String
    let size: String
    let price: Int
}

extension ProductViewData: IProductCDO {
    init(product: Product, endpoint: ProductEndpoint, itemId: Int) {
        self.productId = product.id
        self.endpoint = endpoint
        self.itemIdentifier = itemId
        self.productName = product.productName
        self.image = product.image
        self.imageCollection = product.imageCollection
        self.description = product.description
        self.material = product.material
        self.colour = product.colour
        self.size = product.size
        self.price = product.price
        self.link = Constants.Links.mainHay
    }
}
