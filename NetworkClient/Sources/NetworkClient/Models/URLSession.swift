//
//  URLSessionProtocol.swift
//  NetworkClient
//
//  Created by Kevin MACHADO on 17/12/2024.
//

import Foundation

public protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
