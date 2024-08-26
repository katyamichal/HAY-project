//
//  InspirationDetailViewData.swift
//  Project
//
//  Created by Catarina Polakowsky on 23.08.2024.
//

import Foundation

struct InspirationDetailViewData {
    let collectionName: String
    let coverImage: String
    let images: [String]
    let description: String
    let products: [ProductCDO]
}

extension InspirationDetailViewData {
    init(with inspiration: InspirationFeed) {
        self.collectionName = inspiration.collectionName
        self.coverImage = inspiration.coverImage
        self.images = inspiration.images
        self.description = inspiration.description
        self.products = inspiration.products.map({ProductCDO(with: $0, type: .favourite)})
    }
}
