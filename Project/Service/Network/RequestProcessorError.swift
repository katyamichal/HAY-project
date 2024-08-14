//
//  RequestProcessorError.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.
//

import Foundation

enum RequestProcessorError: Error {
    case wrongURL(URLComponents)
    case urlSessionError
    case noInternetConnection(String = "No Internet Connection")
    case serverError(String = "Invalid API Key")
    case invalidResponse(String = "Invalid response from server")
    case decodingError(String = "Error parsing server response")
    case invalidURL(String = "Invalid URL")
    case unauthorized
    case statusCode(Int)
}
