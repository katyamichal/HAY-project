//
//  LikeButtonManager.swift
//  Project
//
//  Created by Catarina Polakowsky on 08.08.2024.
//

import Foundation
struct Products {
    var products: [Product]
}

final class LikeButtonManager {
    var favoriteProducts = Observable(Products(products: []))
    static let shared = LikeButtonManager()
    private let coreDataService: any ICoreDataService = CoreDataService.shared
    
    private init() {}
    
    func changeProductStatus(with product: Product) {
         if let favoriteIndex = favoriteProducts.value?.products.firstIndex(of: product) {
             favoriteProducts.value?.products.remove(at: favoriteIndex)
             print("Product removed from favorites")
         } else {
             favoriteProducts.value?.products.append(product)
             print("Product added to favorites")
         }
    }
}
