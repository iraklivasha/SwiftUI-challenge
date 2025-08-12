//
//  MovieDemoTests.swift
//  MovieDemoTests
//
//  Created by Yasir Anis on 12/08/2025.
//

import XCTest
@testable import MovieDemo

final class NetworkingTests: XCTestCase {

    func testNetworking() async {
        do {
            let sut = try Networking().createRequest(resource: MovieListResource())
            XCTAssertEqual(sut.url?.relativePath, "/3/movie/popular")
            XCTAssertEqual(sut.allHTTPHeaderFields?.count, 2)
            XCTAssertNotNil(sut.allHTTPHeaderFields?["Authorization"])
        } catch {
            XCTFail("error: \(error)")
            return
        }

    }
}
