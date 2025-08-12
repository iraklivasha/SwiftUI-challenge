//
//  MovieService.swift
//  MovieDemo
//
//  Created by Yasir Anis on 12/08/2025.
//
import Foundation
protocol MovieServiceType {
    func list() async throws -> Movies
}
class MovieService : MovieServiceType {
    let networking: NetworkingType
    init(networking: NetworkingType) {
        self.networking = networking
    }
    func list() async throws -> Movies {
        let resource = MovieListResource()
        let dto = try await networking.request(resource: resource)
        return dto.movies
    }
}

