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
    
    func changeProductStatus(with product: IProductCDO, increment: Bool) {
        let product = ProductCDO(with: product, type: .basket)
        if let id = basketProducts.value?.products.firstIndex(where: {$0.productId == product.productId }) {
            changeProductCount(with: product.productId, at: id, increment: increment)
        } else {
            addBasketProduct(with: product)
        }
    }
    
    func deleteFromBasket(with id: Int, completion: @escaping (Result<String, Error>) -> Void) {
        coreDataService.deleteProduct(productType: .basket, id: id) { [weak self] result in
            switch result {
            case .success(let message):
                defer { completion(.success("Success to delete product")) }
                print(message)
                self?.fetchBasketProducts()
                
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
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
        defer { fetchBasketProducts() }
        coreDataService.add(productType: .basket, product: product)
    }
    
    func changeProductCount(with id: Int, at index: Int, increment: Bool) {
        coreDataService.updateBasketCount(for: id, increment: increment) { [weak self] result in
            switch result {
            case .success(let message):
                print(message)
                self?.fetchBasketProducts()
            case .failure(let error):
                print(error)
            }
        }
    }
}
