//
//  MovieListDTO.swift
//  MovieDemo
//
//  Created by Yasir Anis on 12/08/2025.
//
import Foundation
typealias Movies = [Movie]
// MARK: - MovieListDTO
struct MovieListDTO: Codable {
    let page: Int
    let movies: Movies
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Movie
struct Movie: Codable {
    let adult: Bool
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originalLanguage: OriginalLanguage
    let originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    var completePosterPath: URL? {
        URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")
    }
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case ja = "ja"
    case zh = "zh"
}
