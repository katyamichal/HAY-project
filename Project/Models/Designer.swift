//
//  Designer.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.
//

import Foundation

struct DesignerResponse: Codable {
    let designers: [Designer]
}

struct Designer: Codable {
    let id: Int
    let designerName: String
    let collectionName: String
    let designerInfo: String
    let description: String
    let designerQuotes: [String]
    let designerImage: String
    let collectionImages: [String]
    let products: [Product]
}
