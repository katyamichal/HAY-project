//
//  Category.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.
//

import Foundation

struct CategoryResponse: Codable {
    let categories: [Category]
}

struct Category: Codable {
    let id: Int
    let categoryName: String
    let products: [Product]
}
