//
//  Product.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.
//

import Foundation

struct Product: Codable, Hashable {
    let id: Int
    let productName: String
    let description: String
    let price: Int
    let image: String
    let imageCollection: [String]
    let material: String
    let size: String
    let colour: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}

