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
    func fetchProducts(completion: (Result<[T], Error>) -> Void)
    func fetchProduct(with id: Int) -> T?
    func deleteProduct(with id: Int)
}

protocol Entity {
    var name: EntityType { get }
}
