// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public protocol NetworkClientProtocol: Sendable {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    func request(_ endpoint: Endpoint) async throws -> Void
}

public struct NetworkClient: NetworkClientProtocol {
    private let session: URLSession
    private let baseURL: URL
    private let rateLimiter: RateLimiter?
    
    public init(
        baseURL: URL,
        session: URLSession = .shared,
        rateLimiter: RateLimiter? = nil
    ) {
        self.baseURL = baseURL
        self.session = session
        self.rateLimiter = rateLimiter
    }
    
    public func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        try await rateLimiter?.checkAndIncrement()
        let request = try createRequest(from: endpoint)
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        try validateResponse(httpResponse)
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    public func request(_ endpoint: Endpoint) async throws {
        let request = try createRequest(from: endpoint)
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        try validateResponse(httpResponse)
    }
    
    private func createRequest(from endpoint: Endpoint) throws -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: true)
        components?.queryItems = endpoint.queryItems.isEmpty ? nil : endpoint.queryItems
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let body = endpoint.body {
            request.httpBody = try JSONEncoder().encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
    
    private func validateResponse(_ response: HTTPURLResponse) throws {
        switch response.statusCode {
        case 200...299:
            return
        case 400:
            throw NetworkError.badRequest
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 500...599:
            throw NetworkError.serverError(response.statusCode)
        default:
            throw NetworkError.unexpectedStatusCode(response.statusCode)
        }
    }
}
