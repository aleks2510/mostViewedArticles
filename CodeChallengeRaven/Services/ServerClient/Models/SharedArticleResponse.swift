//
//  SharedArticleResponse.swift
//  CodeChallengeRaven
//
//  Created by Alejandro Lopez Villalobos on 31/12/24.
//

import Foundation

struct SharedResponse: Decodable {
    let status: String
    let copyright: String
    let num_results: Int
    let results: [ArticleResponse]
}
