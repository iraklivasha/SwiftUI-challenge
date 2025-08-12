//
//  MoviesListVM.swift
//  MovieDemo
//
//  Created by Yasir Anis on 12/08/2025.
//
import Foundation

class MoviesListViewModel: ObservableObject {
    enum ViewState {
        case loading
        case error
        case list
    }
    let service: MovieServiceType
    let onSelect:(Movie) -> Void
    @Published var movies: Movies = []
    @Published var viewState: ViewState = .loading
    @Published var selectedMovie: Movie? = nil
    init(service: MovieServiceType, onSelect:@escaping (Movie) -> Void) {
        self.service = service
        self.onSelect = onSelect
        loadMovies()
    }
    func loadMovies() {
        viewState = .loading
        Task {
            do {
                let fetchedMovies = try await service.list()
                await MainActor.run {
                    self.movies = fetchedMovies
                    self.viewState = .list
                }
            } catch {
                await MainActor.run {
                    self.viewState = .error
                }
            }
        }
    }
}
