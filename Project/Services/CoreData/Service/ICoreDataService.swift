//
//  ICoreDataService.swift
//  Project
//
//  Created by Catarina Polakowsky on 18.07.2024.
//

import Foundation

protocol ICoreDataService: AnyObject {
    func add(productType: EntityType,product: IProductCDO, count: Int?)
    func fetchProducts(productType: EntityType, completion: @escaping (Result<[IProductCDO], Error>) -> Void)
    func updateBasketCount(with id: Int)
    func deleteProduct(productType: EntityType, id: Int)
}

protocol Entity {
    var typeName: EntityType { get }
}
