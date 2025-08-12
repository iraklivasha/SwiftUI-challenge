//
//  MoviesDetailsBuilder.swift
//  MovieDemo
//
//  Created by Yasir Anis on 12/08/2025.
//
import Foundation

class MoviesDetailsViewModel: ObservableObject {
    let movie: Movie
    init(movie: Movie) {
        self.movie = movie
    }
}
