//
//  Inspiration.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.
//

import Foundation

struct Inspiration: Codable {
    let inspiration: [InspirationFeed]
}

struct InspirationFeed: Codable {
    let id: Int
    let collectionName: String
    let coverImage: String
    let description: String
    let products: [Product]
    let images: [String]
}
