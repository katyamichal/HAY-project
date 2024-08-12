//
//  IFavouriteProductCoreDataService.swift
//  Project
//
//  Created by Catarina Polakowsky on 18.07.2024.
//

import Foundation

protocol ICoreDataService: AnyObject {
    associatedtype T: Entity
    func add(_ product: T)
    func fetchProducts(productType: EntityType, completion: @escaping (Result<[T], Error>) -> Void)
    func fetchProduct(with id: Int) -> T?
    func deleteProduct(with id: Int)
}

protocol Entity {
    var typeName: EntityType { get }
}
