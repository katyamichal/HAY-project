//
//  CoreDataService.swift
//  Project
//
//  Created by Catarina Polakowsky on 18.07.2024.
//

import Foundation
import CoreData

// TODO: - add FirebaseStorage to get fav and on-buy products in the core data service

final class CoreDataService {
    static let shared = CoreDataService()
    private init() {}
}

extension CoreDataService: ICoreDataService {
    typealias T = ProductCDO
    
    // MARK: - Add
    
    func add(_ product: ProductCDO) {
        defer {
            PersistantContainerStorage.saveContext()
        }
        let newFavouriteProduct = FavouriteProduct(context: PersistantContainerStorage.persistentContainer.viewContext)
        
        newFavouriteProduct.identifier = Int32(product.productId)
        newFavouriteProduct.endpoint = product.endpoint.description
        newFavouriteProduct.itemIdentifier = Int16(product.itemIdentifier)
        newFavouriteProduct.name = product.productName
        newFavouriteProduct.price = Int32(product.price)
        newFavouriteProduct.image = product.image
    }
    
    // MARK: - Fetching
    
    func fetchProducts(productType: EntityType, completion: @escaping (Result<[ProductCDO],Error>) -> Void) {
        do {
            let products = try getProducts(productType: productType)
            completion(.success(products))
        } catch {
            completion(.failure(error))
        }
    }

    func fetchProduct(with id: Int, completion: @escaping (Result<ProductCDO, Error>) -> Void) {
        let context = PersistantContainerStorage.persistentContainer.viewContext
        let request = FavouriteProduct.fetchRequest()
        request.predicate = NSPredicate(format: "identifier == %d", id)
        
        do {
            let favouriteProducts = try context.fetch(request)
            if let favouriteProduct = favouriteProducts.first {
                let product = ProductCDO(
                    productId: Int(favouriteProduct.identifier),
                    endpoint: ProductEndpoint.init(favouriteProduct.endpoint),
                    itemIdentifier: Int(favouriteProduct.itemIdentifier),
                    productName: favouriteProduct.name,
                    price: Int(favouriteProduct.price),
                    image: favouriteProduct.image,
                    typeName: .favourite
                )
                completion(.success(product))
            }
        } catch {
            completion(.failure(error))
        }
    }

    func deleteProduct(with id: Int) {
        defer { PersistantContainerStorage.saveContext() }
        let context = PersistantContainerStorage.persistentContainer.viewContext
        let request = FavouriteProduct.fetchRequest()
        let idNumber = NSNumber(value: id)
        let predicate = NSPredicate(format: "identifier == %@", idNumber)
        request.predicate = predicate
        
        do {
            let products = try context.fetch(request)
            products.forEach { context.delete($0) }
        } catch let error as NSError {
            print("Error to delete: \(error)")
        }
    }
}

private extension CoreDataService {
    func getProducts(productType: EntityType) throws -> [ProductCDO] {
        let context = PersistantContainerStorage.persistentContainer.viewContext
        let request = FavouriteProduct.fetchRequest()
        
        do {
            let favouriteProducts = try context.fetch(request)
            let products = favouriteProducts.map { favouriteProduct in
                ProductCDO(
                    productId: Int(favouriteProduct.identifier),
                    endpoint: ProductEndpoint.init(favouriteProduct.endpoint),
                    itemIdentifier: Int(favouriteProduct.itemIdentifier),
                    productName: favouriteProduct.name,
                    price: Int(favouriteProduct.price),
                    image: favouriteProduct.image,
                    typeName: .favourite
                )
            }
            return products
        } catch {
            throw error
        }
    }
}
