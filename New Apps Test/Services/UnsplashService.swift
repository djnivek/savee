//
//  UnsplashService.swift
//  New Apps Test
//
//  Created by Michel-André Chirita on 06/03/2024.
//

/*
 --------------------------------------------------
 -- Voodoo New Apps Tech Test
 -- BOOSTRAP FILE
 -- Feel free to modify or dismiss it as you like !
 --------------------------------------------------
 */

import Foundation
import NetworkClient

actor UnsplashService {
    private let networkClient: NetworkClient
    private let authToken: String
    
    init(
        baseURL: URL = URL(string: "https://api.unsplash.com")!,
        authToken: String = "Client-ID 8j7cdQS9HM1tfIomk_dUwqrIZ7wnymEECz6xk6OPP6k"
    ) {
        let rateLimiter = RateLimiter(limit: 50, timeWindow: 3600)
        self.networkClient = NetworkClient(baseURL: baseURL, rateLimiter: rateLimiter)
        self.authToken = authToken
    }
    
    func getDiscoverPhotos(page: Int = 1, perPage: Int = 30) async throws -> [UnsplashImage] {
        try await createAndExecuteRequest(
            path: "/photos",
            queryItems: defaultQueryItems(page: page, perPage: perPage)
        )
    }
    
    func getCirclePhotos(page: Int = 1, perPage: Int = 30) async throws -> [UnsplashImage] {
        var queryItems = defaultQueryItems(page: page, perPage: perPage)
        queryItems.append(URLQueryItem(name: "query", value: "home"))
        
        let response: SearchResponse = try await createAndExecuteRequest(
            path: "/search/photos",
            queryItems: queryItems
        )
        return response.results
    }
    
    private func createAndExecuteRequest<T: Decodable>(
        path: String,
        queryItems: [URLQueryItem]
    ) async throws -> T {
        let endpoint = Endpoint(
            path: path,
            headers: ["Authorization": authToken],
            queryItems: queryItems
        )
        return try await networkClient.request(endpoint)
    }
    
    private func defaultQueryItems(page: Int, perPage: Int) -> [URLQueryItem] {
        [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
    }
}

private extension UnsplashService {
    struct SearchResponse: Decodable {
        let results: [UnsplashImage]
    }
}
