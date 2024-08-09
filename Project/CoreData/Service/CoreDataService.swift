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
    typealias T = Product
    
    // MARK: - Add

    func add(_ product: Product) {
        defer {
            PersistantContainerStorage.saveContext()
        }
        let newFavouriteProduct = FavouriteProduct(context: PersistantContainerStorage.persistentContainer.viewContext)
        
        newFavouriteProduct.id = Int32(product.id)
        newFavouriteProduct.name = product.productName
        newFavouriteProduct.productDescription = product.description
        newFavouriteProduct.price = Int64(product.price)
        newFavouriteProduct.image = product.image
        if let data = try? JSONSerialization.data(withJSONObject: product.imageCollection) {
            newFavouriteProduct.imageCollection = data
        }
        newFavouriteProduct.material = product.material
        newFavouriteProduct.size = product.size
        newFavouriteProduct.colour = product.colour
        
    }
    
    // MARK: - Fetching

    func fetchProducts(completion: (Result<[Product], Error>) -> Void) {
        let context = PersistantContainerStorage.persistentContainer.viewContext
        let request = FavouriteProduct.fetchRequest()
        do {
            let favouriteProducts = try context.fetch(request)
            let products = favouriteProducts.map { favouriteProduct in
                Product(id: Int(favouriteProduct.id),
                        productName: favouriteProduct.name,
                        description: favouriteProduct.productDescription,
                        price: Int(favouriteProduct.price),
                        image: favouriteProduct.image ?? "",
                        imageCollection: [],
                        material: favouriteProduct.material,
                        size: favouriteProduct.size,
                        colour: favouriteProduct.colour)
                
            }
            completion(.success(products))
        } catch {
            print("faiiled to fetch favourite products")
            completion(.failure(error))
        }
    }
    
    func fetchProduct(with id: Int) -> Product? {
        nil
    }
    
    func deleteProduct(with id: Int) {
        
    }
}
