//
//  MoviesListView.swift
//  MovieDemo
//
//  Created by Yasir Anis on 12/08/2025.
//


import SwiftUI

struct MoviesListView: View {
    @ObservedObject var viewModel: MoviesListViewModel
    var body: some View {
        VStack {
            switch viewModel.viewState {
            case .loading:
                Loading()
            case .error:
                Error(onRetry: viewModel.loadMovies)
            case .list:
                MoivesList(
                    movies: $viewModel.movies,
                    onSelect: {
                        viewModel.onSelect($0)
                    })
            }
        }
    }
}
fileprivate struct Error: View {
    var onRetry: (() -> Void)
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            VStack(spacing: 24) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.red)
                Text("Something went wrong")
                    .font(.callout)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                Button(action: {
                    onRetry()
                }) {
                    Text("Retry")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 40)
            }
            .multilineTextAlignment(.center)
        }
    }
}
fileprivate struct Loading: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            VStack {
                ProgressView()
                    .scaleEffect(1.5)
                Text("Loading...")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .padding(.top, 16)
            }
        }
    }
}
fileprivate struct MoivesList: View {
    @Binding var movies: Movies
    var onSelect: ((Movie) -> Void)
    var body: some View {
        List(movies, id: \.id) { movie in
            MovieListItemView(
                imageUrl: movie.completePosterPath ?? URL(string: "https://via.placeholder.com/150")!,
                title: movie.title,
                releaseYear: "\(movie.releaseDate)"
            ).onTapGesture {
                onSelect(movie)
            }
            
        }
    }
}
#Preview {
    MoviesListView(
        viewModel: {
            let vm = MoviesListViewModel(service: MockMovieService(), onSelect: {_ in })
            vm.viewState = .error
            return vm
        }()
    )
}
#Preview {
    MoviesListView(
        viewModel: {
            let vm = MoviesListViewModel(service: MockMovieService(), onSelect: {_ in })
            vm.viewState = .loading
            return vm
        }()
    )
}
#Preview {
    MoviesListView(
        viewModel: {
            let vm = MoviesListViewModel(service: MockMovieService(), onSelect: {_ in })
            vm.viewState = .list
            return vm
        }()
    )
}
struct MockMovieService: MovieServiceType {
    func list() async throws -> Movies {
        return []
    }
}
