//
//  MovieListResourse.swift
//  MovieDemo
//
//  Created by Yasir Anis on 12/08/2025.
//
import Foundation
struct MovieListResource: ResourceType {
    typealias Response = MovieListDTO
    
    var method: HTTPMethod = .get
    
    var path: String = "/3/movie/popular"
    
    var parameters: [String : Parameter] = [
        "language": .query("en-US"),
        "page": .query("1")
    ]
    
    var baseURL: String = "https://api.themoviedb.org"
    
    var modifiers: [ResourceModifier] = [.authorizationHeader]
    
    func parse(data: Data, response: HTTPURLResponse) throws -> MovieListDTO {
        guard (200...299).contains(response.statusCode) else {
            throw URLError(.init(rawValue: response.statusCode))
        }
        do {
            let result = try JSONDecoder().decode(MovieListDTO.self, from: data)
            return result
        } catch {
            throw URLError(.cannotParseResponse)
        }
    }
}
