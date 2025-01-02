//
//  ViewedArticleDetails.swift
//  CodeChallengeRaven
//
//  Created by Alejandro Lopez Villalobos on 01/01/25.
//

import SwiftUI
import Kingfisher

struct ViewedArticleDetails: View {
    @Environment(\.dismiss) private var dismiss
    private let item: ArticleResponse
    private var itemThumbnailURL: URL? {
        let media = item.media
        guard let image = media.first(where: { $0.type == "image" }) else { return nil }
        guard let mediaMetadata = image.media_metadata.first(where: {$0.format == "mediumThreeByTwo440"}) else { return nil }
        return URL(string: mediaMetadata.url)
    }
    
    public init(_ item: ArticleResponse) {
        self.item = item
    }
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ScrollView {
                Rectangle()
                    .fill(.clear)
                    .overlay {
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
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: 400)
                            .clipShape(.rect(cornerRadius: 8))
                            .transition(.identity)
                    }
                    .frame(height: 400)
                    .visualEffect { content, proxy in
                        content
                            .offset(
                                y: proxy.frame(in: .scrollView).minY > 0 ? -proxy.frame(in: .scrollView).minY : 0
                            )
                    }
                VStack(alignment: .leading, spacing: 5) {
                    Text(self.item.title)
                        .font(.title)
                    Text("\(self.item.source) | \(self.item.published_date)")
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundStyle(.gray)
                    Text(self.item.abstract)
                    
                    Text(self.item.byline)
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.vertical, 20)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
            }
            .scrollIndicators(.hidden)
            .ignoresSafeArea()
            .frame(width: size.width, height: size.height)
            .background {
                Rectangle()
                    .foregroundStyle(.white)
                    .ignoresSafeArea()
            }
            .overlay(alignment: .topLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.largeTitle)
                        .imageScale(.medium)
                        .contentShape(.rect)
                        .foregroundStyle(.white, .black)
                }
                .buttonStyle(.plain)
                .padding()
            }
            .navigationBarBackButtonHidden()
        }
    }
}
