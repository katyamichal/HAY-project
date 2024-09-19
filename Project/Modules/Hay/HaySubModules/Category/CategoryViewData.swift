//
//  CategoryViewData.swift
//  Project
//
//  Created by Catarina Polakowsky on 14.07.2024.
//

import Foundation

struct CategoryViewData {
    let id: Int
    let categoryName: String
    let products: [ProductCDO]
}

extension CategoryViewData {
    init(with category: Category) {
        self.id = category.id
        self.categoryName = category.categoryName
        self.products = category.products.map({ProductCDO(with: $0, endpoint: .categories, itemIdentifier: category.id, type: .favourite)})
    }
}
