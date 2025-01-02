//
//  ServerClientService.swift
//  CodeChallengeRaven
//
//  Created by Alejandro Lopez Villalobos on 30/12/24.
//

import Foundation

class ServerClientService {
    private let cache = UserDefaults.standard
    private var urlSession: URLSession {
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 30.0
        return session
    }
    private let jsonEncoder: JSONEncoder = JSONEncoder()
    private var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    init() { }
    
    public func request<T: Decodable>(
        _ endpoint: ServiceEndpoint,
        printResponse: Bool = false
    ) async throws -> T {
        return try await request(endpoint, requestData: Optional<Data>.none, printResponse: printResponse)
    }
    
    public func request<S: Encodable, T: Decodable>(
        _ endpoint: ServiceEndpoint,
        requestData: S? = nil,
        printResponse: Bool = false
    ) async throws -> T {
        guard let url = endpoint.url else { throw ServerClientError.invalidURL }
        let requestData = try await self.createRequest(
            url: url,
            requestMethod: endpoint.requestMethod,
            encodableData: requestData,
            printResponse: printResponse
        )
        do {
            return try self.jsonDecoder.decode(T.self, from: requestData)
        } catch {
            throw ServerClientError.decodingError(error)
        }
    }
    
    private func createRequest<T: Encodable>(
        url: URL,
        requestMethod: HTTPMethod,
        headers: [String: String]? = nil,
        encodableData: T? = nil,
        printResponse: Bool = false
    ) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = requestMethod.rawValue
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            let httpResponse = (response as? HTTPURLResponse)?.statusCode
            print("\(url.relativePath) | \(requestMethod.rawValue) | \(httpResponse ?? 0)")
            if let data = encodableData {
                request.httpBody = try self.jsonEncoder.encode(data)
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw ServerClientError.statusCode((response as? HTTPURLResponse)?.statusCode ?? 0)
            }
            if printResponse {
                self.logJSONResponse(data: data)
            }
            cacheData(for: url, data: data)
            return data
        } catch {
            if let cachedData = getCachedData(for: url) {
                print("\(url.relativePath) | \(requestMethod.rawValue) | Cached Data")
                if printResponse {
                    self.logJSONResponse(data: cachedData)
                }
                return cachedData
            }
            throw ServerClientError.unknown(error)
        }
        
    }
    
    private func logJSONResponse(data: Data) {
        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("JSON Response:\n\(jsonString)")
        } else {
            print("Failed to serialize JSON response.")
        }
    }
    
    private func cacheData(for url: URL, data: Data) {
        cache.set(data, forKey: url.absoluteString)
    }
    
    private func getCachedData(for url: URL) -> Data? {
        return cache.data(forKey: url.absoluteString)
    }
}
