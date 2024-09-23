//
//  BuyButtonManager.swift
//  Project
//
//  Created by Catarina Polakowsky on 20.09.2024.
//

import Foundation

struct BasketProducts {
    var products: [BasketProductCDO]
}

final class BuyButtonManager {
    var basketProducts = Observable(BasketProducts(products: []))
    static let shared = BuyButtonManager()
    
    private let coreDataService = CoreDataService.shared
    
    private init() {
        fetchBasketProducts()
        print("BuyButtonManager Init")
    }
    
    func changeProductStatus(with product: IProductCDO) {
        let product = ProductCDO(with: product, type: .basket)
        if let id = basketProducts.value?.products.firstIndex(where: {$0.productId == product.productId }) {
            changeProductCount(with: product.productId, at: id)
        } else {
            addBasketProduct(with: product)
        }
    }
}

private extension BuyButtonManager {
    func fetchBasketProducts() {
        coreDataService.fetchProducts(productType: .basket) { [weak self] result in
            switch result {
            case .success(let products):
                self?.basketProducts.value?.products = products as? [BasketProductCDO] ?? []
            case .failure(let error):
                print("Error to fetch favourite products: \(error.localizedDescription)")
            }
        }
    }
    
    func addBasketProduct(with product: IProductCDO) {
        coreDataService.add(productType: .basket, product: product)
         let product = BasketProductCDO(with: product, count: 1)
        basketProducts.value?.products.append(product)
        print("Product add to basketProducts")
    }
    
    func changeProductCount(with id: Int, at index: Int) {
        defer {
            fetchBasketProducts()
        }
        coreDataService.updateBasketCount(with: id)
        
        print("Product update of basketProducts")
    }
}
