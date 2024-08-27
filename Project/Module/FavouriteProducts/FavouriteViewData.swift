//
//  FavouriteViewData.swift
//  Project
//
//  Created by Catarina Polakowsky on 19.07.2024.
//

import Foundation

struct FavouriteViewData {
    let productId: Int
    let endpoint: ProductEndpoint
    let itemIdentifier: Int
    let name: String
    let price: Int
    let image: String
    var typeName: EntityType
}

extension FavouriteViewData {
    init(with productCDO: IProductCDO) {
        self.productId = productCDO.productId
        self.endpoint = productCDO.endpoint
        self.itemIdentifier = productCDO.itemIdentifier
        self.name = productCDO.productName
        self.price = productCDO.price
        self.image = productCDO.image
        self.typeName = .favourite
    }
}
