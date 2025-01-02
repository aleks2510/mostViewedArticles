//
//  SharedArticleCell.swift
//  CodeChallengeRaven
//
//  Created by Alejandro Lopez Villalobos on 31/12/24.
//

import SwiftUI
import Kingfisher

struct SharedArticleCell: View {
    private let item: ArticleResponse
    private var itemThumbnailURL: URL? {
        let media = item.media
        guard let image = media.first(where: { $0.type == "image" }) else { return nil }
        guard let mediaMetadata = image.media_metadata.first(where: {$0.format == "Standard Thumbnail"}) else { return nil }
        return URL(string: mediaMetadata.url)
    }
    private let onTap: (ArticleResponse) -> Void
    
    public init(_ item: ArticleResponse, onTap: @escaping (ArticleResponse) -> Void = {_ in}) {
        self.item = item
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: {onTap(item)}){
            HStack(alignment: .top) {
                KFImage(itemThumbnailURL)
                    .placeholder {
                        Rectangle()
                            .foregroundStyle(.gray.opacity(0.5))
                            .overlay {
                                Image(systemName: "photo")
                                    .foregroundStyle(.gray)
                            }
                        
                    }
                    .cacheMemoryOnly()
                    .fade(duration: 0.25)
                    .resizable()
                    .anchorPreference(key: AnchorKey.self, value: .bounds, transform: { ["\(item.id)": $0] })
                    .cornerRadius(8)
                    .frame(width: 90, height: 90)
                
                
                
                VStack(alignment: .leading, spacing: 5){
                    Text(item.section)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.gray)
                    Text(item.title)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2, reservesSpace: true)
                        .foregroundStyle(.black)
                        .minimumScaleFactor(0.75)
                        .font(.headline)
                    Spacer()
                    Text("\(item.byline) ■ \(item.published_date)")
                        .foregroundStyle(.black)
                        .font(.caption2)
                        .foregroundStyle(.black.opacity(0.75))
                    
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(RoundedRectangle(cornerRadius: 8)
            .foregroundStyle(Color.white)
            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2))
        .frame(height: 140)
    }
    
    private func getScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
}
