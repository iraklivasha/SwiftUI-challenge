//
//  MovieDemoApp.swift
//  MovieDemo
//
//  Created by Yasir Anis on 12/08/2025.
//

import SwiftUI

@main
struct MovieDemoApp: App {
    public let dependencies: DependenciesContainerType = DependenciesContainer()
    var body: some Scene {
        WindowGroup {
            MoviesCoordinatorFlow(dependencies: dependencies)
        }
    }
}
