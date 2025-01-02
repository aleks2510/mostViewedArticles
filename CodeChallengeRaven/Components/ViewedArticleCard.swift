//
//  ViewedArticleCard.swift
//  CodeChallengeRaven
//
//  Created by Alejandro Lopez Villalobos on 31/12/24.
//

import SwiftUI
import Kingfisher

struct ViewedArticleCard: View {
    private let item: ArticleResponse
    private var itemThumbnailURL: URL? {
        let media = item.media
        guard let image = media.first(where: { $0.type == "image" }) else { return nil }
        guard let mediaMetadata = image.media_metadata.first(where: {$0.format == "mediumThreeByTwo210"}) else { return nil }
        return URL(string: mediaMetadata.url)
    }
    private let onTap: (ArticleResponse) -> Void
    
    public init(_ item: ArticleResponse, onTap: @escaping (ArticleResponse) -> Void = {_ in}) {
        self.item = item
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: {onTap(item)}){
            VStack {
                KFImage(itemThumbnailURL)
                    .placeholder {
                        Rectangle()
                            .foregroundStyle(.gray.opacity(0.5))
                            .overlay {
                                Image(systemName: "photo")
                                    .font(.title)
                                    .foregroundStyle(.gray)
                            }
                        
                    }
                    .cacheMemoryOnly()
                    .fade(duration: 0.25)
                    .cornerRadius(8)
                    .frame(height: 150)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                
                VStack(alignment: .leading, spacing: 3){
                    Text(self.item.source)
                        .font(.headline)
                        .foregroundStyle(.black)
                    Text(self.item.title)
                        .font(.subheadline)
                        .foregroundStyle(.black.opacity(0.5))
                        .multilineTextAlignment(.leading)
                        .lineLimit(2,reservesSpace: true)
                        .minimumScaleFactor(0.8)
                    Text(self.item.published_date)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
                
            }
        }
        .frame(maxWidth: 240)
        .padding(.vertical, 10)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color.white)
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
        }
    }
}
