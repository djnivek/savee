//
//  Tab.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//


enum Tab: String, Hashable {
    case challenge
    case explorer
    
    var icon: String {
        switch self {
        case .challenge:
            return "camera.circle.fill"
        case .explorer:
            return "square.grid.2x2"
        }
    }
    
    var title: String {
        switch self {
        case .challenge:
            return "Challenge"
        case .explorer:
            return "Explorer"
        }
    }
}

enum ExplorerSection: String, Hashable {
    case discover
    case circle
    
    var title: String {
        switch self {
        case .discover:
            return "Discover"
        case .circle:
            return "Circle"
        }
    }
}
