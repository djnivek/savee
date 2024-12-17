// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public protocol NetworkClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    func request(_ endpoint: Endpoint) async throws -> Void
}

public struct NetworkClient: NetworkClientProtocol {
    private let session: URLSession
    private let baseURL: URL
    
    public init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    public func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
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
        let url = baseURL.appendingPathComponent(endpoint.path)
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
