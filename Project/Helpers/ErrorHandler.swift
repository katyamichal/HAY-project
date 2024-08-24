//
//  ErrorHandler.swift
//  Project
//
//  Created by Catarina Polakowsky on 24.08.2024.
//

import Foundation

final class ErrorHandler {
    static func getErrorResponse(with requestError: Error) -> String {
        if let error = requestError as? RequestProcessorError {
            return configureKnownResponseError(with: error)
        } else {
            return Constants.LoadingMessage.unknown
        }
    }
    
    private static func configureKnownResponseError(with type: RequestProcessorError) -> String {
        switch type {
        case .noInternetConnection:
            return Constants.LoadingMessage.noInternetConnection
            
        case .invalidURL, .decodingError, .invalidResponse:
            return Constants.LoadingMessage.failFetchData
            
        case .urlSessionError:
            return Constants.LoadingMessage.urlSessionError
            
        case .serverError:
            return Constants.LoadingMessage.serverError
            
        case .unauthorized, .statusCode(_), .wrongURL(_):
            return Constants.LoadingMessage.unknown
        }
    }
}
