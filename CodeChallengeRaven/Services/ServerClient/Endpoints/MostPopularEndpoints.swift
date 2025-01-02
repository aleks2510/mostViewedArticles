//
//  MostPopularEndpoints.swift
//  CodeChallengeRaven
//
//  Created by Alejandro Lopez Villalobos on 30/12/24.
//

import Foundation

public enum MostPopularEndpoints: ServiceEndpoint {
    case viewed(period: String)
    case emailed(period: String)
    case shared(period: String)
    
    
    var url: URL? {
        switch self {
        case .viewed(let period):
            return buildUrlComponents(pathParameters: ["period": period], queryParameters: apiKeyParam).url
        case .emailed(let period):
            return buildUrlComponents(pathParameters: ["period": period], queryParameters: apiKeyParam).url
        case .shared(let period):
            return buildUrlComponents(pathParameters: ["period": period], queryParameters: apiKeyParam).url
        }
    }
    
    var path: String {
        switch self {
        case .viewed:
            return "/svc/mostpopular/v2/viewed/{period}.json"
        case .emailed:
            return "/svc/mostpopular/v2/emailed/{period}.json"
        case .shared:
            return "/svc/mostpopular/v2/shared/{period}/facebook.json"
        }
    }
    
    var requestMethod: HTTPMethod {
        switch self {
        case .viewed: return .GET
        case .emailed: return .GET
        case .shared: return .GET
        }
    }
}
fileprivate let apiKeyParam = ["api-key":"qTl6HA9lEk9bHwEMNSrdjRAceMnSqQEZ"]
