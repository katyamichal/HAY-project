//
//  CategoryViewData.swift
//  Project
//
//  Created by Catarina Polakowsky on 14.07.2024.
//

import Foundation

struct CategoryViewData {
    let categoryName: String
    let products: [ProductCDO]
}

extension CategoryViewData {
    init(with category: Category) {
        self.categoryName = category.categoryName
        self.products = category.products.map({ProductCDO(with: $0, type: .favourite)})
    }
}
