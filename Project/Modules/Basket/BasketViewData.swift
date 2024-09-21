//
//  BasketViewData.swift
//  Project
//
//  Created by Catarina Polakowsky on 19.09.2024.
//

import Foundation

struct BasketViewData: IBasketProductCDO {
    let productId: Int
    let endpoint: ProductEndpoint
    let itemIdentifier: Int
    let productName: String
    let price: Int
    let image: String
    var typeName: EntityType
    var count: Int
}

extension BasketViewData {
    init(with productCDO: IBasketProductCDO) {
        self.productId = productCDO.productId
        self.endpoint = productCDO.endpoint
        self.itemIdentifier = productCDO.itemIdentifier
        self.productName = productCDO.productName
        self.price = productCDO.price
        self.image = productCDO.image
        self.typeName = .basket
        self.count = productCDO.count
    }
}
