//
//  LikeButtonManager.swift
//  Project
//
//  Created by Catarina Polakowsky on 08.08.2024.
//

import Foundation

struct LikeProducts {
    var products: [ProductCDO]
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
            addfavouriteProduct(with: product)
        }
    }
}

private extension LikeButtonManager {
    func fetchFavouriteProducts() {
        coreDataService.fetchProducts(productType: .favourite) { [weak self] result in
            switch result {
            case .success(let product):
                self?.favouriteProducts.value?.products = product.reversed()
            case .failure(let error):
                print("Error to fetch favourite products: \(error.localizedDescription)")
            }
        }
    }
    
    func addfavouriteProduct(with product: ProductCDO) {
        coreDataService.add(product)
        favouriteProducts.value?.products.append(product)
        print("Product add to favorites")
    }
    
    func deleteProduct(with id: Int, at index: Int) {
        coreDataService.deleteProduct(with: id)
        favouriteProducts.value?.products.remove(at: index)
        print("Product removed from favorites")
    }
}

