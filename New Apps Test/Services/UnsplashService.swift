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
    
    init() {
        let baseURL = URL(string: "https://api.unsplash.com")!
        // For applications in demo mode, the Unsplash API currently places a limit of 50 requests per hour
        let rateLimiter = RateLimiter(limit: 50, timeWindow: 3600)
        
        self.networkClient = NetworkClient(
            baseURL: baseURL,
            rateLimiter: rateLimiter
        )
    }
    
    func getPhotos(page: Int = 1, perPage: Int = 30) async throws -> [UnsplashImage] {
        let endpoint = Endpoint(
            path: "/photos",
            headers: [
                "Authorization": "Client-ID 8j7cdQS9HM1tfIomk_dUwqrIZ7wnymEECz6xk6OPP6k"
            ],
            queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "\(perPage)")
            ]
        )
        
        return try await networkClient.request(endpoint)
    }
}
