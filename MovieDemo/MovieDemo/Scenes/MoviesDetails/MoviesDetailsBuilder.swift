//
//  MoviesDetailsBuilder.swift
//  MovieDemo
//
//  Created by Yasir Anis on 12/08/2025.
//

class MoviesDetailsBuilder {
    class func build(movie: Movie) -> MoviesDetailsView {
        let viewModel = MoviesDetailsViewModel(movie: movie)
        return MoviesDetailsView(viewModel: viewModel)
    }
}
