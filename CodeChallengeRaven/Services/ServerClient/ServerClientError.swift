//
//  ServerClientError.swift
//  CodeChallengeRaven
//
//  Created by Alejandro Lopez Villalobos on 30/12/24.
//

import Foundation

public enum ServerClientError: Error  {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decodingError(Error)
    case encodingError(Error)
    case unknown(Error)
    
    var localizedDescription: String {
        switch self {
            
        case .invalidURL:
            return "The URL given is invalid"
        case .invalidResponse:
            return "The response from the server was invalid."
        case .statusCode(let code):
            return "Received an unexpected status code: \(code)."
        case .decodingError(let error):
            return "Failed to decode the response: \(error.localizedDescription)."
        case .encodingError(let error):
            return "Failed to encode the request body: \(error.localizedDescription)."
        case .unknown(let error):
            return "An unknown error occurred: \(error.localizedDescription)."
        }
    }
}
