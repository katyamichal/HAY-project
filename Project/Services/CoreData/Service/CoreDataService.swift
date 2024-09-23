//
//  CoreDataService.swift
//  Project
//
//  Created by Catarina Polakowsky on 18.07.2024.
//

import Foundation
import CoreData

final class CoreDataService {
    static let shared = CoreDataService()
    private init() {}
}

extension CoreDataService: ICoreDataService {

    // MARK: - Add Product
    
    func add(productType: EntityType, product: IProductCDO, count: Int? = nil) {
        defer {
            PersistantContainerStorage.saveContext()
        }
        
        let context = PersistantContainerStorage.persistentContainer.viewContext
        
        switch productType {
        case .favourite:
            let newProduct = HayProduct(context: context)
            newProduct.identifier = Int16(product.productId)
            newProduct.endpoint = product.endpoint.description
            newProduct.itemIdentifier = Int16(product.itemIdentifier)
            newProduct.name = product.productName
            newProduct.price = Int32(product.price)
            newProduct.image = product.image
            newProduct.isFavourite = true
            
        case .basket:
            guard let count = count else {
                print("Error: Count is required for basket products")
                return
            }
            let newBasketProduct = Basket(context: context)
            newBasketProduct.productId = Int16(product.productId)
            newBasketProduct.count = Int16(1)
        }
    }
    
    // MARK: - Fetch Products
    
    func fetchProducts(productType: EntityType, completion: @escaping (Result<[IProductCDO], Error>) -> Void) {
        do {
            let products = try getProducts(productType: productType)
            completion(.success(products))
        } catch {
            completion(.failure(error))
        }
    }
    
    // MARK: - Delete Product
    
    func deleteProduct(productType: EntityType, id: Int) {
        defer { PersistantContainerStorage.saveContext() }
        let context = PersistantContainerStorage.persistentContainer.viewContext
        
        let request: NSFetchRequest<NSFetchRequestResult>
        
        switch productType {
        case .favourite:
            request = HayProduct.fetchRequest()
        case .basket:
            request = Basket.fetchRequest()
        }
        
        request.predicate = NSPredicate(format: "identifier == %d", id)
        
        do {
            let products = try context.fetch(request) as? [NSManagedObject]
            products?.forEach { context.delete($0) }
        } catch let error as NSError {
            print("Error deleting product: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Update Basket Product
#warning("use a closure to pass an operation of add up or take off")
    func updateBasketCount(with id: Int) {
        defer {
            PersistantContainerStorage.saveContext()
        }
        let context = PersistantContainerStorage.persistentContainer.viewContext
        let request: NSFetchRequest<NSFetchRequestResult> = Basket.fetchRequest()
        request.predicate = NSPredicate(format: "productId == %d", id)
        
        do {
            let products = try context.fetch(request) as? [Basket]
            let product = products?.first(where: {$0.productId == id})
            product?.count += 1
        } catch let error as NSError {
            print("Error update product count: \(error.localizedDescription)")
        }
    }
}

// MARK: - Helper function to Fetch All Products by Type

private extension CoreDataService {
    
    func getProducts(productType: EntityType) throws -> [IProductCDO] {
        let context = PersistantContainerStorage.persistentContainer.viewContext
        
        switch productType {
        case .favourite:
            let request = HayProduct.fetchRequest()
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
            let request = Basket.fetchRequest()
            let basketProducts = try context.fetch(request)

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
                        count: Int(basketProducts.first(where: { $0.productId == product.identifier })?.count ?? 0 )
                    )
                }
            } else {
                return []
            }
        }
    }
}
