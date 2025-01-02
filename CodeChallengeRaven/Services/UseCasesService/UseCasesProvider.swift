//
//  UseCasesProvider.swift
//  CodeChallengeRaven
//
//  Created by Alejandro Lopez Villalobos on 30/12/24.
//

import SwiftUI

final class UseCasesProvider: ObservableObject {
    private let serverClient = ServerClientService()
    public var isLoading: Bool = false
    
    public func getMostViewed(period: Int = 1) async -> [ArticleResponse]{
        var results: [ArticleResponse] = []
        self.isLoading = true
        do {
            let responses : ViewedResponse = try await self.serverClient.request(MostPopularEndpoints.viewed(period: "\(period)"))
            withAnimation {
                results = responses.results
            }
        } catch {
            print(error.localizedDescription)
        }
        self.isLoading = false
        return results
    }
    
    public func getMostShared(period: Int = 1) async -> [ArticleResponse] {
        var results: [ArticleResponse] = []
        self.isLoading = true
        do {
            let responses : SharedResponse = try await self.serverClient.request(MostPopularEndpoints.shared(period: "\(period)"))
            withAnimation {
                results = responses.results
            }
        } catch {
            print(error.localizedDescription)
        }
        self.isLoading = false
        return results
    }
}

struct EmptyResponse: Decodable {
    
}
