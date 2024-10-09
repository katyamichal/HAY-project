//
//  LikeButtonManager.swift
//  Project
//
//  Created by Catarina Polakowsky on 08.08.2024.
//

import Foundation

struct LikeProducts {
    var products: [any IProductCDO]
}

final class LikeButtonManager {
    var favouriteProducts = Observable(LikeProducts(products: []))
    static let shared = LikeButtonManager()
    
    private let coreDataService = CoreDataService.shared
    
    private init() {
        fetchFavouriteProducts()
        print("LikeManager Init")
    }
    
    func changeProductStatus(with product: IProductCDO) {
        let product = ProductCDO(with: product, type: .favourite)
        if let id = favouriteProducts.value?.products.firstIndex(where: {$0.productId == product.productId }) {
            deleteProduct(with: product.productId, at: id)
        } else {
            addFavouriteProduct(with: product)
        }
    }
}

private extension LikeButtonManager {
    func fetchFavouriteProducts() {
        coreDataService.fetchProducts(productType: .favourite) { [weak self] result in
            switch result {
            case .success(let products):
                self?.favouriteProducts.value?.products = products as? [ProductCDO] ?? []
            case .failure(let error):
                print("Error to fetch favourite products: \(error.localizedDescription)")
            }
        }
    }
    
    func addFavouriteProduct(with product: ProductCDO) {
        defer { fetchFavouriteProducts() }
        coreDataService.add(productType: .favourite, product: product)
    }
    
    func deleteProduct(with id: Int, at index: Int) {
        coreDataService.deleteProduct(productType: .favourite, id: id) { [weak self] result in
            switch result {
            case .success(let message):
                print(message)
                self?.fetchFavouriteProducts()
            case .failure(let error):
                print(error)
            }
        }
    }
}
