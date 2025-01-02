//
//  ContentView.swift
//  CodeChallengeRaven
//
//  Created by Alejandro Lopez Villalobos on 31/12/24.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @EnvironmentObject private var useCasesProvider: UseCasesProvider
    @EnvironmentObject private var appCoordinator: AppCoordinator
    @State private var mostViewedArticles: [ArticleResponse] = []
    @State private var mostSharedArticles: [ArticleResponse] = []
    @State private var selectedSharedArticle: ArticleResponse? = nil
    @State private var showDetails: Bool = false
    @State private var heroProgress: CGFloat = 0
    @State private var showHeroView: Bool = true
    
    private var selectedArticleThumbnailURL: URL? {
        guard let media = selectedSharedArticle?.media else { return nil }
        guard let image = media.first(where: { $0.type == "image" }) else { return nil }
        guard let mediaMetadata = image.media_metadata.first(where: {$0.format == "mediumThreeByTwo210"}) else { return nil }
        return URL(string: mediaMetadata.url)
    }
    var body: some View {
        ScrollView {
            Text("Most Viewed Articles")
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            if self.useCasesProvider.isLoading {
                ProgressView()
                    .frame(height: 180)
            } else {
                if !self.mostViewedArticles.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(mostViewedArticles) { article in
                                ViewedArticleCard(article) { article in
                                    self.appCoordinator.navigate(to: .details(article: article))
                                }
                            }
                        }
                        
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                    }
                    .scrollIndicators(.hidden)
                } else {
                    VStack {
                        Image("Empty 1")
                        Text("Oops no most viewed articles to display try later")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .padding(.horizontal, 20)
                        
                    }
                    .padding(.vertical, 20)
                    
                }
            }
            
            Text("Most Shared on Facebook")
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            
            if !self.useCasesProvider.isLoading {
                if !self.mostSharedArticles.isEmpty {
                    ForEach(mostSharedArticles) {
                        article in
                        SharedArticleCell(article) { article in
                            self.selectedSharedArticle = article
                            self.showDetails = true
                            withAnimation(.snappy(duration: 0.35, extraBounce: 0), completionCriteria: .logicallyComplete) {
                                heroProgress = 1
                            } completion: {
                                Task {
                                    try? await Task.sleep(for: .seconds(0.1))
                                    showHeroView = false
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                } else {
                    VStack {
                        Image("Empty 2")
                        Text("Oops no most shared articles to display! Try later")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .padding(.horizontal, 20)
                        
                    }
                    .padding(.vertical, 20)
                }
            } else {
                ProgressView()
                    .padding(.vertical, 50)
            }
        }
        .scrollIndicators(.hidden)
        
        .overlay {
            SharedArticleDetails(
                selectedArticle: $selectedSharedArticle,
                heroProgress: $heroProgress,
                showHeroView: $showHeroView,
                showDetails: $showDetails
            )
        }
        .overlayPreferenceValue(AnchorKey.self) { value in
            GeometryReader { geometry in
                if let selectedSharedArticle,
                   let source = value["\(selectedSharedArticle.id)"],
                   let destination = value["DESTINATION"] {
                    let sourceRect = geometry[source]
                    let destinationRect = geometry[destination]
                    
                    let diffSize = CGSize(
                        width: destinationRect.width - sourceRect.width,
                        height: destinationRect.height - sourceRect.height
                    )
                    
                    let diffOrigin = CGPoint(
                        x: destinationRect.minX - sourceRect.minX,
                        y: destinationRect.minY - sourceRect.minY
                    )
                    
                    KFImage(selectedArticleThumbnailURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            width: sourceRect.width + (diffSize.width * heroProgress),
                            height: sourceRect.height + (diffSize.height * heroProgress)
                        )
                        .clipShape(.rect(cornerRadius: 8))
                        .offset(
                            x: sourceRect.minX + (diffOrigin.x * heroProgress),
                            y: sourceRect.minY + (diffOrigin.y * heroProgress)
                        )
                        .opacity(showHeroView ? 1 : 0)
                }
            }
        }
        .navigationTitle(self.showDetails ? "" : "Discover")
        .task {
            self.mostViewedArticles = await useCasesProvider.getMostViewed()
            self.mostSharedArticles = await useCasesProvider.getMostShared()
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
    .environmentObject(UseCasesProvider())
    .environmentObject(AppCoordinator())
}
