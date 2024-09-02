//
//  DataFetcher.swift
//  Project
//
//  Created by Catarina Polakowsky on 01.09.2024.
//

import Foundation

#warning("refactor for type flexebility")

protocol ProductFetchService {
    func fetchProduct(itemId: Int, productId: Int) async throws -> ProductViewData?
}

struct CategoriesFetchService: ProductFetchService {
    private let service: HayServiceable

    init(service: HayServiceable) {
        self.service = service
    }

    func fetchProduct(itemId: Int, productId: Int) async throws -> ProductViewData? {
        let categoriesResponse = try await service.getCategories()
        let categories = categoriesResponse.categories
        guard let category = categories.first(where: { $0.id == itemId }),
              let product = category.products.first(where: { $0.id == productId }) else {
            return nil
        }
        return ProductViewData(product: product, endpoint: .categories, itemId: itemId)
    }
}

struct DesignersFetchService: ProductFetchService {
    private let service: HayServiceable

    init(service: HayServiceable) {
        self.service = service
    }

    func fetchProduct(itemId: Int, productId: Int) async throws -> ProductViewData? {
        let designersResponse = try await service.getDesigners()
        let designers = designersResponse.designers
        guard let designer = designers.first(where: { $0.id == itemId }),
              let product = designer.products.first(where: { $0.id == productId }) else {
            return nil
        }
        return ProductViewData(product: product, endpoint: .designers, itemId: itemId)
    }
}

struct InspirationFetchService: ProductFetchService {
    private let service: HayServiceable

    init(service: HayServiceable) {
        self.service = service
    }

    func fetchProduct(itemId: Int, productId: Int) async throws -> ProductViewData? {
        let inspirationResponse = try await service.getInspiration()
        let inspiration = inspirationResponse.inspiration
        guard let inspirationFeed = inspiration.first(where: { $0.id == itemId }),
              let product = inspirationFeed.products.first(where: { $0.id == productId }) else {
            return nil
        }
        return ProductViewData(product: product, endpoint: .inspiration, itemId: itemId)
    }
}
