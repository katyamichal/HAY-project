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
    var price: Int { get  }
    var image: String { get  }
}

// MARK: - Type used to save data into CoreData Storage

struct ProductCDO: Equatable, Entity {
    let productId: Int
    let endpoint: ProductEndpoint
    let itemIdentifier: Int
    let productName: String
    let price: Int
    let image: String
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
        self.typeName = type
    }
}

// MARK: - Type of Endpoint to get data from server(if saved)

enum ProductEndpoint {
    case inspiration
    case categories
    case designers
    
    var description: String {
        switch self {
        case .categories: return "categories"
        case .designers: return "designers"
        case .inspiration: return "inspiration"
        }
    }
}

// MARK: - Initializer to transform string endpoint keeping in core data storage into ProductCDO

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
