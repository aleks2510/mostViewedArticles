//
//  CodeChallengeRavenTests.swift
//  CodeChallengeRavenTests
//
//  Created by Alejandro Lopez Villalobos on 31/12/24.
//

import Testing
@testable import CodeChallengeRaven

struct ServerClientTests {
    private var serverClient: ServerClientService!
    
    init() {
        self.serverClient = ServerClientService()
    }
    
    @Test("Fail request with invalid URL") func failRequestWithEmptyURL() async throws {
        do {
            let response: EmptyResponse = try await serverClient.request(UnitTestEndpoints.empty)
            #expect(response == nil)
        } catch {
            #expect(error != nil, "Returned error as expected")
        }
    }
    
    @Test("Invalid APIKey should throw error") func invalidAPIKeyRequest() async throws {
        do {
            let response: EmptyResponse = try await serverClient.request(UnitTestEndpoints.invalidAPIKey)
            #expect(response == nil, "Should not received a value because decoder is wrong")
        } catch {
            #expect(error != nil, "Should return an error for invalid api key")
        }
    }
    
    @Test("Valid request but wrong decoding") func validRequestWrongDecode() async throws {
        do {
            let response: ArticleResponse = try await serverClient.request(MostPopularEndpoints.shared(period: "1"))
            #expect(response == nil)
        } catch {
            #expect(error != nil, "Should throw an error ")
        }
    }
    
    @Test("Valid request valid decoding") func validRequestValidDecode() async throws {
        do {
            let response: SharedResponse = try await serverClient.request(MostPopularEndpoints.shared(period: "1"))
            #expect(response != nil)
            #expect(response.status == "OK")
            #expect(response.results.count > 0)
        } catch {
            #expect(error == nil)
        }
    }
    
    @Test("Valid article response on call") func validArticleResponseValue() async throws {
        do {
            let response: SharedResponse = try await serverClient.request(MostPopularEndpoints.shared(period: "1"))
            #expect(response != nil)
            #expect(response.status == "OK")
            #expect(response.results.count > 0)
            let article = try #require(response.results[0] as ArticleResponse)
            #expect(!article.title.isEmpty)
        } catch {
            #expect(error == nil)
        }
    }

}
