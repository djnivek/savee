//
//  RateLimiter.swift
//  NetworkClient
//
//  Created by Kevin MACHADO on 18/12/2024.
//

import Foundation

public actor RateLimiter {
    private var requestCount: Int = 0
    private var lastResetTime: Date = Date()
    private let limit: Int
    private let timeWindow: TimeInterval
    
    public init(limit: Int, timeWindow: TimeInterval) {
        self.limit = limit
        self.timeWindow = timeWindow
    }
    
    public func checkAndIncrement() async throws {
        let now = Date()
        if now.timeIntervalSince(lastResetTime) >= timeWindow {
            requestCount = 0
            lastResetTime = now
        }
        
        guard requestCount < limit else {
            throw NetworkError.rateLimited(
                retryAfter: timeWindow - now.timeIntervalSince(lastResetTime)
            )
        }
        
        requestCount += 1
    }
}
