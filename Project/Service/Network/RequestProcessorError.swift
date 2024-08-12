//
//  RequestProcessorError.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.
//

import Foundation

enum RequestProcessorError: Error {
    case wrongURL(URLComponents)
    case unexpectedResponse
    case unableToDecode
    case unauthorized
    case statusCode(Int)
    case unknown
}
