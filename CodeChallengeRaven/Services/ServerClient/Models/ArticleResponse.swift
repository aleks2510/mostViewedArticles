//
//  ArticleResponse.swift
//  CodeChallengeRaven
//
//  Created by Alejandro Lopez Villalobos on 01/01/25.
//

import Foundation

struct ArticleResponse: Decodable, Identifiable, Hashable {
    let url: String
    let adx_keywords: String
    let subsection: String
    let section: String
    let id: Int
    let asset_id: Int
    let nytdsection: String
    let byline: String
    let type: String
    let title: String
    let abstract: String
    let published_date: String
    let source: String
    let updated: String
    let des_facet: [String]
    let org_facet: [String]
    let geo_facet: [String]
    let media: [MediaResponse]
    let uri: String
}

struct MediaResponse: Decodable, Hashable {
    let type: String
    let subtype: String
    let caption: String
    let copyright: String
    let approved_for_syndication: Int
    let media_metadata: [MediaMetadataResponse]
    
    enum CodingKeys: String, CodingKey {
        case type, subtype, caption, copyright,approved_for_syndication
        case media_metadata = "media-metadata"
    }
}

struct MediaMetadataResponse: Decodable, Hashable {
    let url: String
    let format: String
    let height: Int
    let width: Int
}
