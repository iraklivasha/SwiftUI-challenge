//
//  NetworkingType.swift
//  MovieDemo
//
//  Created by Yasir Anis on 12/08/2025.
//

import Foundation
public protocol NetworkingType {
    func request<R: ResourceType>(resource: R) async throws -> R.Response
}
final class Networking: NetworkingType {
    let apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5M2EzMmJjZDBhZDdkMjM0NzcyY2YxMmUyYWJmODRjYSIsIm5iZiI6MTc1NTAwMzYyNC45ODIsInN1YiI6IjY4OWIzYWU4YzI3YmIzNjk4YmI3MDcyYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.vegH7b3MJR0jHM_HthPCHwMm_pr-o-_lRIT68gXZPDw"
    
    func request<R: ResourceType>(resource: R) async throws -> R.Response {
        var request = try createRequest(resource: resource)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw NSError.invalidResponse
        }
        return try resource.parse(data: data, response: response)
    }
    func createRequest<R: ResourceType>(resource: R) throws -> URLRequest {
        guard var components = URLComponents(string: resource.baseURL + resource.path) else {
            throw NSError.invalidURL
        }
        var headers: [String: String] = [:]
        headers["accept"] = "application/json"

        if resource.modifiers.contains(.authorizationHeader) {
            headers["Authorization"] = "Bearer \(apiKey)"
        }
        for (key, parameter) in resource.parameters {
            switch parameter {
            case .header(let headerValue):
                headers[key] = headerValue
            case .query:
                break
            }
        }
        // Append query parameters
        var queryItems = components.queryItems ?? []
        for (key, parameter) in resource.parameters {
            switch parameter {
            case .query(let queryValue):
                queryItems.append(URLQueryItem(name: key, value: queryValue))
            default:
                break
            }
        }
        components.queryItems = queryItems
        guard let url = components.url else {
            throw NSError.invalidURLAfterParameters
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        request.httpMethod = resource.method.rawValue.uppercased()
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }

}

extension NSError {
    static var invalidURL: NSError {
        NSError(domain: "Networking", code: 1000, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
    }
    static var invalidURLAfterParameters: NSError {
        NSError(domain: "Networking", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Invalid URL after adding query parameters"])
    }
    static var invalidResponse: NSError {
        NSError(domain: "Networking", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
    }
}
