//
//  MoviewListBuilder.swift
//  MovieDemo
//
//  Created by Yasir Anis on 12/08/2025.
//

class MoviesListBuilder {
    class func build(dependencies: DependenciesContainerType, onSelect: @escaping (Movie) -> Void) -> MoviesListView {
        let service = MovieService(networking: dependencies.networking)
        let viewModel = MoviesListViewModel(service: service, onSelect: onSelect)
        return MoviesListView(viewModel: viewModel)
    }
}
