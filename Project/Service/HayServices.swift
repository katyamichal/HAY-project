//
//  HayServices.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.
//

import Foundation

protocol HayServiceable {
    func getInspiration() async throws -> Inspiration
    func getDesigners() async throws -> DesignerResponse
    func getCategories() async throws -> CategoryResponse
}

struct HayService: HayServiceable, API {
    
    func getInspiration() async throws -> Inspiration {
        return try await performRequest(endpoint: HayEndpoints.inspiration, responseModel: Inspiration.self)
    }
    
    func getDesigners() async throws -> DesignerResponse {
        return try await performRequest(endpoint: HayEndpoints.designers, responseModel: DesignerResponse.self)
    }
    
    func getCategories() async throws -> CategoryResponse {
        return try await performRequest(endpoint: HayEndpoints.categories, responseModel: CategoryResponse.self)
    }
}
