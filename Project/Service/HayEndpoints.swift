//
//  HayEndpoints.swift
//  HAYproject
//
//  Created by Catarina Polakowsky on 08.07.2024.
//

import Foundation

enum HayEndpoints {
    case inspiration
    case designers
    case categories
}

extension HayEndpoints: Endpoint {
    var path: String {
        switch self {
        case .inspiration:
            return "/inspiration"
        case .designers:
            return "/designers"
        case .categories:
            return "/categories"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .inspiration, .designers, .categories:
            return RequestMethod.get
        }
    }    
}
