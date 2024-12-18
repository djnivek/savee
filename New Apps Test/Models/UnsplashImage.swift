//
//  UnsplashImage.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//

import Foundation

struct UnsplashImage: Decodable, Identifiable, Sendable {
    let id: String
    let urls: ImageURLs
    let user: User
    
    struct ImageURLs: Decodable {
        let raw: String
        let regular: String
        let thumb: String
    }
    
    struct User: Decodable {
        let name: String
        let username: String
    }
}
