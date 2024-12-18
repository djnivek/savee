//
//  HTTPMethod.swift
//  NetworkClient
//
//  Created by Kevin MACHADO on 17/12/2024.
//

public enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
