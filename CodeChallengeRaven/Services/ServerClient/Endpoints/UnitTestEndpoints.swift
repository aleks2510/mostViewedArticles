//
//  UnitTestEndpoints.swift
//  CodeChallengeRaven
//
//  Created by Alejandro Lopez Villalobos on 02/01/25.
//

import Foundation

public enum UnitTestEndpoints: ServiceEndpoint {
    case empty
    case invalidAPIKey
    
    var url: URL? {
        switch self {
        case .empty:
            buildUrlComponents().url
        case .invalidAPIKey:
            buildUrlComponents(pathParameters: ["period": "1"], queryParameters: wrongAPI).url
        }
    }
    
    var path: String {
        switch self {
        case .empty:
            "/"
        case .invalidAPIKey:
            "/svc/mostpopular/v2/viewed/{period}.json"
        }
    }
    
    var requestMethod: HTTPMethod {
        switch self {
        case .empty:
                .GET
        case .invalidAPIKey:
                .GET
        }
        
    }
}

fileprivate let wrongAPI = ["api-key":"qTl6HA9sdfsdfQEZ"]
