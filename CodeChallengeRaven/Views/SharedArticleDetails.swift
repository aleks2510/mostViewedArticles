//
//  ArticleDetails.swift
//  CodeChallengeRaven
//
//  Created by Alejandro Lopez Villalobos on 01/01/25.
//

import SwiftUI
import Kingfisher

struct SharedArticleDetails: View {
    @Binding var selectedArticle: ArticleResponse?
    @Binding var heroProgress: CGFloat
    @Binding var showHeroView: Bool
    @Binding var showDetails: Bool
    @GestureState private var isDragging: Bool = false
    @State private var offset: CGFloat = .zero
    private var itemThumbnailURL: URL? {
        guard let media = selectedArticle?.media else { return nil }
        guard let image = media.first(where: { $0.type == "image" }) else { return nil }
        guard let mediaMetadata = image.media_metadata.first(where: {$0.format == "mediumThreeByTwo440"}) else { return nil }
        return URL(string: mediaMetadata.url)
    }
    
    var body: some View {
        if let selectedArticle, showDetails {
            GeometryReader { proxy in
                let size = proxy.size
                ScrollView {
                    VStack {
                        Rectangle()
                            .fill(.clear)
                            .overlay {
                                if !showHeroView {
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
                            }
                            .frame(height: 400)
                            .anchorPreference(key: AnchorKey.self, value: .bounds, transform: { ["DESTINATION": $0] })
                            .visualEffect { content, proxy in
                                content
                                    .offset(
                                        y: proxy.frame(in: .scrollView).minY > 0 ? -proxy.frame(in: .scrollView).minY : 0
                                    )
                            }
                        VStack(alignment: .leading, spacing: 5) {
                            Text(selectedArticle.title)
                                .font(.title)
                            Text("\(selectedArticle.source) | \(selectedArticle.published_date)")
                                .font(.callout)
                                .fontWeight(.medium)
                                .foregroundStyle(.gray)
                            Text(selectedArticle.abstract)
                            
                            Text(selectedArticle.byline)
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.vertical, 20)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                    }
                    
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
                        self.showHeroView = true
                        withAnimation(.snappy(duration: 0.35, extraBounce: 0), completionCriteria: .logicallyComplete) {
                            heroProgress = 0.0
                        } completion: {
                            self.showDetails = false
                            self.selectedArticle = nil
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .imageScale(.medium)
                            .contentShape(.rect)
                            .foregroundStyle(.white, .black)
                    }
                    .buttonStyle(.plain)
                    .padding()
                    .opacity(showHeroView ? 0 : 1)
                    .animation(.snappy(duration: 0.2, extraBounce: 0), value: showHeroView)
                }
                .offset(x:size.width - (size.width * heroProgress))
                .overlay(alignment: .leading) {
                    Rectangle()
                        .fill(.clear)
                        .frame(width: 10)
                        .contentShape(.rect)
                        .gesture(
                            DragGesture()
                                .updating($isDragging, body: { _, out, _ in
                                    out = true
                                })
                                .onChanged ({ value in
                                    var translation = value.translation.width
                                    translation = isDragging ? translation : .zero
                                    translation = translation > 0 ? translation : 0
                                    let dragProgress = 1.0 - (translation / size.width )
                                    let cappedProgress = min(max(0, dragProgress), 1)
                                    heroProgress = cappedProgress
                                    offset = translation
                                    if !showHeroView {
                                        showHeroView = true
                                    }
                                })
                                .onEnded({ value in
                                    let velocity = value.velocity.width
                                    if (offset + velocity) > (size.width * 0.8) {
                                        withAnimation(.snappy(duration: 0.35, extraBounce: 0),completionCriteria: .logicallyComplete) {
                                            heroProgress = .zero
                                        } completion: {
                                            offset = .zero
                                            showDetails = false
                                            showHeroView = true
                                            self.selectedArticle = nil
                                        }
                                    } else {
                                        withAnimation(.snappy(duration: 0.35, extraBounce: 0),completionCriteria: .logicallyComplete) {
                                            heroProgress = 1.0
                                            offset = .zero
                                        } completion: {
                                            showHeroView = false
                                        }
                                    }
                                    
                                })
                        )
                }
            }
        }
    }
}
/*
 #Preview {
 ArticleDetails(
 selectedArticle:
 .constant(
 .init(
 url: "https://www.nytimes.com/2024/12/30/nyregion/trump-carroll-appeal-denied.html",
 adx_keywords: "Libel and Slander;United States Politics and Government;Sex Crimes;Appeals Courts (US);Decisions and Verdicts;Suits and Litigation (Civil);Carroll, E Jean;Trump, Donald J;Kaplan, Lewis A;Kaplan, Roberta A;Sauer, D John (1974- );Chin, Denny;Carney, Susan Laura;Perez, Myrna (1974- )",
 subsection: "",
 section: "New York",
 id: 100000009900991,
 asset_id: 100000009900991,
 nytdsection: "new york",
 byline: "By Lola Fadulu",
 type: "Article",
 title: "Trump Loses Appeal of Carroll’s $5 Million Award in Sex-Abuse Case",
 abstract: "The president-elect had asked a court to overturn the defamation judgment against him in the case, which centered on E. Jean Carroll’s account of a sexual attack in a dressing room.",
 published_date: "2024-12-30",
 source: "New York Times",
 updated: "2024-12-31 07:46:00",
 des_facet: [],
 org_facet: [],
 geo_facet: [],
 media: [
 MediaResponse(
 type: "image",
 subtype: "photo",
 caption: "A federal appeals panel rejected a move by President-elect Donald J. Trump to overturn a $5 million judgment won by E. Jean Carroll, right.",
 copyright: "Dave Sanders for The New York Times",
 approved_for_syndication: 1,
 media_metadata: [
 MediaMetadataResponse(
 url: "https://static01.nyt.com/images/2024/12/30/multimedia/30ny-trump-carroll-htzc/30ny-trump-carroll-htzc-mediumThreeByTwo440.jpg",
 format: "mediumThreeByTwo440",
 height: 293,
 width: 440
 )
 ]
 )
 ],
 uri: "nyt://article/d7c06548-3419-53d6-ac0d-6cdd0ed59478"
 )
 ),
 showDetails:
 .constant(true)
 )
 }
 */
