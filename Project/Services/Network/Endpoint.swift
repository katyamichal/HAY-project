//
//  Endpoint.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
//    var header: [String: String]? { get }
//    var body: [String: String]? { get }
}

extension Endpoint {
    var scheme: String {
        return "https"
    }
    
    var host: String {
     //return "haydenmark.free.beeceptor.com"
     //  return "hayproject.free.beeceptor.com"
   //return "hayhayhay.free.beeceptor.com"
        "caaec00476976ecc426b.free.beeceptor.com"
    }
}

enum RequestMethod: String {
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}
