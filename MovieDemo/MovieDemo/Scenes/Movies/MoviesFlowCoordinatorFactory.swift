//
//  MoviesCordinator.swift
//  MovieDemo
//
//  Created by Yasir Anis on 12/08/2025.
//

import SwiftUI

class MoviesCoordinator: ObservableObject {
    enum Route: Hashable {
        case movieDetails(Movie)

        static func == (lhs: MoviesCoordinator.Route, rhs: MoviesCoordinator.Route) -> Bool {
            switch (lhs, rhs) {
            case (.movieDetails(let l), .movieDetails(let r)):
                return l.id == r.id
            }
        }

        func hash(into hasher: inout Hasher) {
            switch self {
            case .movieDetails(let movie):
                hasher.combine(movie.id)
            }
        }
    }
    @Published var path = NavigationPath()

    let dependencies: DependenciesContainerType

    lazy var moviesListView: MoviesListView = {
        return MoviesListBuilder.build(dependencies: dependencies) { [weak self] movie in
            guard let self else { return }
            self.pushToDetails(movie: movie)
        }
    }()
    init(dependencies: DependenciesContainerType) {
        self.dependencies = dependencies
    }
    
    func pushToDetails(movie: Movie) {
        path.append(Route.movieDetails(movie))
    }
}

struct MoviesCoordinatorFlow: View {
    let dependencies: DependenciesContainerType
    @ObservedObject private var coordinator: MoviesCoordinator
    init(dependencies: DependenciesContainerType) {
        self.dependencies = dependencies
        self.coordinator = MoviesCoordinator(dependencies: dependencies)
    }
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.moviesListView
            .navigationDestination(for: MoviesCoordinator.Route.self) { route in
                switch route {
                case .movieDetails(let movie):
                    MoviesDetailsBuilder.build(movie: movie)
                }
            }
        }
    }
}

