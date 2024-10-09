//
//  ProductCDO.swift
//  Project
//
//  Created by Catarina Polakowsky on 12.08.2024.
//

import Foundation
// MARK: - Protocol is a type of product is saved in CoreData Storage

protocol IProductCDO {
    var productId: Int { get }
    var endpoint: ProductEndpoint { get }
    var itemIdentifier: Int { get }
    var productName: String { get }
    var price: Int { get }
    var image: String { get }
    var isFavourite: Bool { get }
}

// MARK: - Type used to save data into CoreData Storage

struct ProductCDO: Equatable {
    let productId: Int
    let endpoint: ProductEndpoint
    let itemIdentifier: Int
    let productName: String
    let price: Int
    let image: String
    var isFavourite: Bool
    var typeName: EntityType
}

// MARK: - Initializer for DTO product fetched from a server

extension ProductCDO {
    init(with product: Product, endpoint: ProductEndpoint, itemIdentifier: Int, type: EntityType) {
        self.productId = product.id
        self.endpoint = endpoint
        self.itemIdentifier = itemIdentifier
        self.productName = product.productName
        self.price = product.price
        self.image = product.image
        self.isFavourite = false
        self.typeName = type
    }
}

// MARK: - Initializer for CDO product fetched from Core Data Storage

extension ProductCDO: IProductCDO {
    init(with product: IProductCDO, type: EntityType) {
        self.productId = product.productId
        self.endpoint = product.endpoint
        self.itemIdentifier = product.itemIdentifier
        self.productName = product.productName
        self.price = product.price
        self.image = product.image
        self.isFavourite = product.isFavourite
        self.typeName = type
    }
}

// MARK: - Enum for Product Endpoints used for server data fetching

enum ProductEndpoint: String {
    case inspiration
    case categories
    case designers
    
    var description: String {
        return self.rawValue
    }
}

// MARK: - Initializer for transforming a String into ProductEndpoint

extension ProductEndpoint {
    init(_ value: String) {
        switch value.lowercased() {
        case "categories": self = .categories
        case "designers": self = .designers
        case "inspiration": self = .inspiration
        default: self.init("none")
            
        }
    }
}

struct BasketProductCDO: IProductCDO {
    let productId: Int
    let endpoint: ProductEndpoint
    let itemIdentifier: Int
    let productName: String
    let price: Int
    let image: String
    var typeName: EntityType = .basket
    var isFavourite: Bool
    var count: Int
}

extension BasketProductCDO {
    init(with productCDO: IProductCDO, count: Int) {
        self.productId = productCDO.productId
        self.endpoint = productCDO.endpoint
        self.itemIdentifier = productCDO.itemIdentifier
        self.productName = productCDO.productName
        self.price = productCDO.price
        self.image = productCDO.image
        self.typeName = .basket
        self.isFavourite = productCDO.isFavourite
        self.count = count
    }
}
