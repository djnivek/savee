//
//  Endpoint.swift
//  NetworkClient
//
//  Created by Kevin MACHADO on 17/12/2024.
//

public struct Endpoint {
    public let path: String
    public let method: HTTPMethod
    public let body: Encodable?
    public let headers: [String: String]
    
    public init(
        path: String,
        method: HTTPMethod = .get,
        body: Encodable? = nil,
        headers: [String: String] = [:]
    ) {
        self.path = path
        self.method = method
        self.body = body
        self.headers = headers
    }
}
