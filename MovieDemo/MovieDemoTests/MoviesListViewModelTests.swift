//
//  MoviesListViewModelTests.swift
//  MovieDemo
//
//  Created by Yasir Anis on 12/08/2025.
//


import XCTest
import Combine
@testable import MovieDemo

final class MoviesListViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    func test_loadMovies_success_updatesMoviesAndState() async {
        let mockMovies = [
            Movie(
                adult: false,
                backdropPath: "backdrop",
                genreIDS: [],
                id: 1,
                originalLanguage: .en,
                originalTitle: "Original",
                overview: "Overview",
                popularity: 1.0,
                posterPath: "poster",
                releaseDate: "2025-01-01",
                title: "Test Movie",
                video: false,
                voteAverage: 8.5,
                voteCount: 100
            )
        ]
        let service = MockService()
        service.moviesToReturn = mockMovies
        let exp = expectation(description: "Movies loaded")
        let sut = MoviesListViewModel(service: service, onSelect: { _ in })
        sut.$viewState
            .dropFirst() // Skip initial loading state
            .sink { state in
                if state == .list {
                    XCTAssertEqual(sut.movies.count, 1)
                    XCTAssertEqual(sut.movies.first?.title, "Test Movie")
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)
        sut.loadMovies()
        wait(for: exp)

    }
    
    func test_loadMovies_failure_updatesStateToError() async {
        struct TestError: Error {}
        let service = MockService()
        service.errorToThrow = TestError()
        let exp = expectation(description: "Movies loaded")
        let sut = MoviesListViewModel(service: service, onSelect: { _ in })
        sut.$viewState
            .dropFirst() // Skip initial loading state
            .sink { state in
                if state == .error {
                    XCTAssertTrue(sut.movies.isEmpty)
                    exp.fulfill()
                }
            }
            .store(in: &cancellables)
        sut.loadMovies()
        wait(for: exp)
    }
}
fileprivate class MockService: MovieServiceType {
    var moviesToReturn: [Movie] = []
    var errorToThrow: Error?
    
    func list() async throws -> [Movie] {
        if let error = errorToThrow {
            throw error
        }
        return moviesToReturn
    }
}
extension XCTestCase {
    func wait(for expectations: XCTestExpectation..., timeout: TimeInterval = 5) {
        wait(for: expectations, timeout: timeout)
    }
}
