//
//  MoviesDetailsBuilder.swift
//  MovieDemo
//
//  Created by Yasir Anis on 12/08/2025.
//

import SwiftUI

struct MoviesDetailsView: View {
    @ObservedObject var viewModel: MoviesDetailsViewModel
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                WebImage.init(
                    url: viewModel.movie.completePosterPath ?? URL(string: "https://via.placeholder.com/150")!,
                    contentMode: .fit,
                    placeholder: {
                        Color.gray.opacity(0.1)
                    }
                )
                .frame(height: 300)

                Text(viewModel.movie.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(viewModel.movie.overview)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("Rating: \(String(format: "%.1f", viewModel.movie.voteAverage))")
                    Spacer()
                    Text("Votes: \(viewModel.movie.voteCount)")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                HStack {
                    Text("Popularity: \(String(format: "%.1f", viewModel.movie.popularity))")
                    Spacer()
                    Text("Release Date: \(viewModel.movie.releaseDate)")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}
#Preview {
    MoviesDetailsView(viewModel: MoviesDetailsViewModel(movie: Movie(adult: false, backdropPath: "/zNriRTr0kWwyaXPzdg1EIxf0BWk.jpg", genreIDS: [], id: 1234821, originalLanguage: .en, originalTitle: "title", overview: "overview", popularity: 1274.2264, posterPath: "/1RICxzeoNCAO5NpcRMIgg1XT6fm.jpg", releaseDate: "2025-07-01", title: "Jurassic World Rebirth", video: false, voteAverage: 6.412, voteCount: 1419)))
    
}
