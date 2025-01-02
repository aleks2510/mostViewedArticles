//
//  AppCoordinator.swift
//  CodeChallengeRaven
//
//  Created by Alejandro Lopez Villalobos on 01/01/25.
//

import Foundation

final class AppCoordinator: ObservableObject {
    @Published var routes: [Route] = []
    @Published var sheetRoute: Route? = nil
    
    func navigate(to screen: Route) {
        guard !routes.contains(screen) else {
            return
        }
        routes.append(screen)
    }
    
    func goBack() {
        _ = routes.popLast()
    }
    
    func reset() {
        routes = []
    }
    
    func replace(stack: [Route]) {
        routes = stack
    }
    
    func presentSheet(_ screen: Route) {
        sheetRoute = screen
    }
    
}


