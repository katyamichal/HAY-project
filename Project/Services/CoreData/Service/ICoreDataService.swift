//
//  ICoreDataService.swift
//  Project
//
//  Created by Catarina Polakowsky on 18.07.2024.
//

import Foundation

protocol ICoreDataService: AnyObject {
    func add(productType: EntityType, product: IProductCDO)
    func fetchProducts(productType: EntityType, completion: @escaping (Result<[IProductCDO], Error>) -> Void)
    func deleteProduct(productType: EntityType, id: Int, completion: @escaping (Result<String, Error>) -> Void)
}
