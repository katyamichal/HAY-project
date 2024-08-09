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
    private let coreDataService = CoreDataService.shared
    
    private init() {
        fetchFavouriteProducts()
    }
    
    func changeProductStatus(with product: Product) {
        defer {
            fetchFavouriteProducts()
        }
         if let favoriteIndex = favoriteProducts.value?.products.firstIndex(of: product) {
        
             favoriteProducts.value?.products.remove(at: favoriteIndex)
             print("Product removed from favorites")
         } else {
            // favoriteProducts.value?.products.append(product)
            
             coreDataService.add(product)
             print("Product added to favorites")
         }
    }
}

private extension LikeButtonManager {
    func fetchFavouriteProducts() {
        coreDataService.fetchProducts { [weak self] result in
            switch result {
            case .success(let product):
                self?.favoriteProducts.value?.products = product
            case .failure(let error):
                print("Error to fetch favourite products: \(error.localizedDescription)")
            }
        }
    }
}
