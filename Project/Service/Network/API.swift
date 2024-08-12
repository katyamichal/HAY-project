//
//  API.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.
//

import Foundation

protocol API {
    func performRequest<HayType: Decodable>(endpoint: Endpoint, responseModel: HayType.Type) async throws -> HayType
}

extension API {
    func performRequest<HayType: Decodable>(endpoint: Endpoint, responseModel: HayType.Type) async throws -> HayType {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        
        guard let url = urlComponents.url else {
            throw RequestProcessorError.wrongURL(urlComponents)
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw RequestProcessorError.unexpectedResponse
            }
            switch response.statusCode {
            case 200..<300:
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let decodedResponse = try? jsonDecoder.decode(HayType.self, from: data) else {
                    throw RequestProcessorError.unableToDecode
                }
                return decodedResponse
            case 401:
                throw RequestProcessorError.unauthorized
            default:
                throw RequestProcessorError.statusCode(response.statusCode)
            }
        } catch {
            throw RequestProcessorError.unknown
        }
    }
}
