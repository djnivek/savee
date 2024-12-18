//
//  Endpoint.swift
//  NetworkClient
//
//  Created by Kevin MACHADO on 17/12/2024.
//

import Foundation

public struct Endpoint: Sendable {
    public let path: String
    public let method: HTTPMethod
    public let body: (any Encodable & Sendable)?
    public let headers: [String: String]
    public let queryItems: [URLQueryItem]
    
    public init(
        path: String,
        method: HTTPMethod = .get,
        body: (any Encodable & Sendable)? = nil,
        headers: [String: String] = [:],
        queryItems: [URLQueryItem] = []
    ) {
        self.path = path
        self.method = method
        self.body = body
        self.headers = headers
        self.queryItems = queryItems
    }
}
