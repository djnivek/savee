//
//  GalleryViewModel.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//

import SwiftUI

protocol GalleryViewModel {
    var state: GalleryState { get }
    var canLoadMore: Bool { get }
    
    func loadInitialImages() async
    func loadNextPageIfNeeded() async
}

enum GalleryState {
    case idle
    /// Represents a loading state, optionally containing images already loaded
    /// to differentiate an initial load from a pagination
    case loading([UnsplashImage]?)
    case loaded([UnsplashImage])
    case error(Error, [UnsplashImage]?)
}
