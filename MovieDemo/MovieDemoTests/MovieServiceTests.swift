//
//  MovieDemoTests.swift
//  MovieDemoTests
//
//  Created by Yasir Anis on 12/08/2025.
//

import XCTest
@testable import MovieDemo

final class MovieServiceTests: XCTestCase {

    func testService() async {
        let sut = MovieService(networking: MockNetworking())
        let movies: [Movie]
        do {
            movies = try await sut.list()
        } catch {
            XCTFail("Expected movies list but got error: \(error)")
            return
        }
        XCTAssertEqual(movies.count, 1)
        XCTAssertEqual(movies.first?.id, 1234821)
        XCTAssertEqual(movies.first?.title, "Jurassic World Rebirth")
        XCTAssertEqual(movies.first?.voteAverage, 6.412)
    }
}
fileprivate class MockNetworking: NetworkingType {
    func request<R>(resource: R) async throws -> R.Response where R : ResourceType {
        return MovieListDTO.mock() as! R.Response
    }
}

private extension MovieListDTO {
    static func mock(
        page: Int = 1,
        totalPages: Int = 1,
        totalResults: Int = 1,
        movies: [Movie] = [
            Movie(
                adult: false,
                backdropPath: "/zNriRTr0kWwyaXPzdg1EIxf0BWk.jpg",
                genreIDS: [],
                id: 1234821,
                originalLanguage: .en,
                originalTitle: "title",
                overview: "overview",
                popularity: 1274.2264,
                posterPath: "/1RICxzeoNCAO5NpcRMIgg1XT6fm.jpg",
                releaseDate: "2025-07-01",
                title: "Jurassic World Rebirth",
                video: false,
                voteAverage: 6.412,
                voteCount: 1419
            )
        ]
    ) -> MovieListDTO {
        MovieListDTO(
            page: page,
            movies: movies,
            totalPages: totalPages,
            totalResults: totalResults
        )
    }
}
