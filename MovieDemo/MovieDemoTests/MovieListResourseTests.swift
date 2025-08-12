//
//  MovieDemoTests.swift
//  MovieDemoTests
//
//  Created by Yasir Anis on 12/08/2025.
//

import XCTest
@testable import MovieDemo

final class MovieListResourseTests: XCTestCase {

    func testMovieListResource() {
        let sut = MovieListResource()
        XCTAssertEqual(sut.baseURL, "https://api.themoviedb.org")
        XCTAssertEqual(sut.path, "/3/movie/popular")
        XCTAssertEqual(sut.method, .get)
        XCTAssertEqual(sut.parameters.count, 2)
        XCTAssertEqual(sut.modifiers.count, 1)
    }
    
}
