//
//  CoreDataService.swift
//  Project
//
//  Created by Catarina Polakowsky on 18.07.2024.
//

import Foundation
import CoreData
#warning("remove singleton and make it DI")
final class CoreDataService {
    static let shared = CoreDataService()
    private init() {}
}

extension CoreDataService: ICoreDataService {
    
    // MARK: - Add Product
    
    func add(productType: EntityType, product: IProductCDO) {
        let context = PersistantContainerStorage.persistentContainer.viewContext
        defer { PersistantContainerStorage.saveContext() }
        
        switch productType {
        case .favourite:
            if let existingProduct = fetchSingleProduct(type: .favourite, id: product.productId) as? HayProduct {
                existingProduct.isFavourite = true
            } else {
                let newProduct = HayProduct(context: context)
                newProduct.identifier = Int16(product.productId)
                newProduct.endpoint = product.endpoint.description
                newProduct.itemIdentifier = Int16(product.itemIdentifier)
                newProduct.name = product.productName
                newProduct.price = Int32(product.price)
                newProduct.image = product.image
                newProduct.isFavourite = true
            }
            
        case .basket:
            let basketProduct = Basket(context: context)
            basketProduct.productId = Int16(product.productId)
            basketProduct.count = 1
        }
    }
    
    // MARK: - Fetch Products
    
    func fetchProducts(productType: EntityType, completion: @escaping (Result<[IProductCDO], Error>) -> Void) {
        do {
            let products = try fetchProducts(by: productType)
            completion(.success(products))
        } catch {
            completion(.failure(error))
        }
    }
    
    // MARK: - Delete Product
    
    func deleteProduct(productType: EntityType, id: Int, completion: @escaping (Result<String, Error>) -> Void) {
        defer { PersistantContainerStorage.saveContext() }
        
        switch productType {
        case .favourite:
            if let product = fetchSingleProduct(type: .favourite, id: id) as? HayProduct {
                if fetchSingleProduct(type: .basket, id: id) is Basket {
                    product.isFavourite = false
                } else {
                    deleteProductFromContext(productType: .favourite, id: id, completion: completion)
                }
            }
        case .basket:
            deleteProductFromContext(productType: .basket, id: id, completion: completion)
        }
    }
    
    // MARK: - Update Basket Product
    
    func updateBasketCount(for id: Int, increment: Bool = true,  completion: @escaping (Result<String, Error>) -> Void) {
        let context = PersistantContainerStorage.persistentContainer.viewContext
        let request: NSFetchRequest<Basket> = Basket.fetchRequest()
        request.predicate = NSPredicate(format: "productId == %d", id)
        
        defer { PersistantContainerStorage.saveContext() }
        
        do {
            defer {
                completion(.success("Success to update basket count"))
            }
            if let basketProduct = try context.fetch(request).first {
                basketProduct.count += increment ? 1 : -1
                if basketProduct.count == 0 {
                    deleteProductFromContext(productType: .basket, id: id, completion: completion)
                }
            }
        } catch {
            print("Error updating basket product count: \(error.localizedDescription)")
            completion(.success("Error to update basket count"))
        }
    }
}

// MARK: - Private Helper Methods

private extension CoreDataService {
    
    // MARK: Fetch products by its type

    func fetchProducts(by productType: EntityType) throws -> [IProductCDO] {
        let context = PersistantContainerStorage.persistentContainer.viewContext
        
        switch productType {
        case .favourite:
            let request = HayProduct.fetchRequest()
            request.predicate = NSPredicate(format: "isFavourite == %@", NSNumber(value: true))
            let products = try context.fetch(request)
            return products.map { product in
                ProductCDO(
                    productId: Int(product.identifier),
                    endpoint: ProductEndpoint(product.endpoint),
                    itemIdentifier: Int(product.itemIdentifier),
                    productName: product.name,
                    price: Int(product.price),
                    image: product.image,
                    isFavourite: product.isFavourite,
                    typeName: .favourite
                )
            }
            
        case .basket:
            let basketRequest = Basket.fetchRequest()
            let basketProducts = try context.fetch(basketRequest)
            let productIds = basketProducts.map { $0.productId }
            
            if !productIds.isEmpty {
                let hayRequest = HayProduct.fetchRequest()
                hayRequest.predicate = NSPredicate(format: "identifier IN %@", productIds)
                let products = try context.fetch(hayRequest)
                return products.map { product in
                    BasketProductCDO(
                        productId: Int(product.identifier),
                        endpoint: ProductEndpoint(product.endpoint),
                        itemIdentifier: Int(product.itemIdentifier),
                        productName: product.name,
                        price: Int(product.price),
                        image: product.image,
                        typeName: .basket,
                        isFavourite: product.isFavourite,
                        count: Int(basketProducts.first { $0.productId == product.identifier }?.count ?? 0)
                    )
                }
            } else {
                return []
            }
        }
    }
    
    // MARK: Fetch a single product by its type

    func fetchSingleProduct(type: EntityType, id: Int) -> Any? {
        let context = PersistantContainerStorage.persistentContainer.viewContext
        
        switch type {
        case .favourite:
            let request: NSFetchRequest<HayProduct> = HayProduct.fetchRequest()
            request.predicate = NSPredicate(format: "identifier == %d", id)
            return try? context.fetch(request).first
            
        case .basket:
            let request: NSFetchRequest<Basket> = Basket.fetchRequest()
            request.predicate = NSPredicate(format: "productId == %d", id)
            return try? context.fetch(request).first
        }
    }
    
    // MARK: Delete a single product by its type
    
    func deleteProductFromContext(productType: EntityType, id: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let context = PersistantContainerStorage.persistentContainer.viewContext
        
        switch productType {
        case .favourite:
            let request = HayProduct.fetchRequest()
            request.predicate = NSPredicate(format: "identifier == %d", id)
            deleteProducts(from: request, in: context, completion: completion)
            
        case .basket:
            let request = Basket.fetchRequest()
            request.predicate = NSPredicate(format: "productId == %d", id)
            deleteProducts(from: request, in: context, completion: completion)
        }
    }
    
    // MARK: Delete all products with current context
    
    func deleteProducts<T: NSManagedObject>(from request: NSFetchRequest<T>, in context: NSManagedObjectContext, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            defer {
                completion(.success("Success to delete product"))
            }
            let products = try context.fetch(request)
            products.forEach { context.delete($0) }
            
        } catch {
            completion(.failure(error))
            print("Error deleting product: \(error.localizedDescription)")
        }
    }
}


