//
//  HomeTab.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//

import Foundation

enum HomeTab: Hashable {
    case today
    case global
    case friends
    
    var title: String {
        switch self {
        case .today: return "Aujourd'hui"
        case .global: return "Global"
        case .friends: return "Amis"
        }
    }
    
    var icon: String {
        switch self {
        case .today: return "camera.fill"
        case .global: return "globe"
        case .friends: return "person.2.fill"
        }
    }
}
