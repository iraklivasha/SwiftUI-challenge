//
//  NetworkResourseType.swift
//  MovieDemo
//
//  Created by Yasir Anis on 12/08/2025.
//
import Foundation

public enum HTTPMethod: String {
    case get
    // TODO: Add other types as required
}
public enum ResourceModifier {
    case authorizationHeader
}
public enum Parameter {
    /**
        URL-encoded query parameter
    */
    case query(String)
    /**
        HTTP header field
    */
    case header(String)
}
public protocol ResourceType {
    associatedtype Response: Decodable

    var method: HTTPMethod { get }

    var path: String { get }

    var parameters: [String: Parameter] { get }

    var baseURL:String { get }

    func parse(data: Data, response: HTTPURLResponse) throws -> Response

    var modifiers: [ResourceModifier] { get }
}
