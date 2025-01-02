//
//  CodeChallengeRavenApp.swift
//  CodeChallengeRaven
//
//  Created by Alejandro Lopez Villalobos on 31/12/24.
//

import SwiftUI

@main
struct CodeChallengeRavenApp: App {
    @StateObject private var appCoordinator = AppCoordinator()
    @StateObject private var useCasesProvider = UseCasesProvider()
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appCoordinator.routes) {
                Group {
                    ContentView()
                }
                .navigationDestination(for: Route.self) { $0 }
                .sheet(item: $appCoordinator.sheetRoute) { $0 }
            }
            .environmentObject(appCoordinator)
            .environmentObject(useCasesProvider)
        }
    }
}
