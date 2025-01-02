//
//  ServiceEndpoint.swift
//  CodeChallengeRaven
//
//  Created by Alejandro Lopez Villalobos on 30/12/24.
//

import Foundation

protocol ServiceEndpoint {
    var url: URL? { get }
    var path: String { get }
    var requestMethod: HTTPMethod { get }
}

extension ServiceEndpoint {
    func buildUrlComponents(
        pathParameters: Dictionary<String, String>? = nil,
        queryParameters: Dictionary<String, Any>? = nil
    ) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.nytimes.com"
        if let pathParameters = pathParameters {
            var newPath: String = self.path
            for (key, value) in pathParameters {
                newPath = self.path.replacingOccurrences(of: "{\(key)}", with: "\(value)")
            }
            urlComponents.path = newPath
        } else {
            urlComponents.path = path
        }
        
        if let queryParameters = queryParameters, !queryParameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            for (key, value) in queryParameters {
                if let stringParam = value as? String {
                    urlComponents.queryItems?.append(URLQueryItem(name: key, value: stringParam))
                }
                else if let stringList = value as? [String] {
                    for item in stringList {
                        urlComponents.queryItems?.append(URLQueryItem(name: key, value: item))
                    }
                }
                else {
                    fatalError("Query parameters currently support 'String' or '[String]' values")
                }
            }
        }
        
        return urlComponents
    }
}
