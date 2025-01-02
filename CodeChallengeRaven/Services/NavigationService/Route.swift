//
//  Route.swift
//  CodeChallengeRaven
//
//  Created by Alejandro Lopez Villalobos on 01/01/25.
//

import SwiftUI

enum Route {
    case details(article: ArticleResponse)
    
}

extension Route: Identifiable {
    
    public var id: Self { self }
    
}

extension Route: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
    
    static func == (lhs: Route, rhs: Route) -> Bool {
        switch(lhs, rhs) {
        case(.details(let lhsPage), .details(let rhsPage)):
            return lhsPage == rhsPage
        }
    }
}

extension Route: View {
    var body: some View {
        switch self {
        case .details(let article):
            return ViewedArticleDetails(article)
        }
    }
}

