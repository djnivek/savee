//
//  MosaicViewModel.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//
import Foundation
import SwiftUI

@Observable
final class MosaicViewModel {
    
    enum State {
        case idle
        /// Represents a loading state, optionally containing images already loaded
        /// to differentiate an initial load from a pagination
        case loading([UnsplashImage]?)
        case loaded([UnsplashImage])
        case error(Error, [UnsplashImage]?)
    }
    
    private let unsplashService: UnsplashService
    private var currentPage = 1
    private let imagesPerPage = 30
    
    var state: State = .idle
    var canLoadMore = true
    private var isLoading = false
    
    init(unsplashService: UnsplashService) {
        self.unsplashService = unsplashService
    }
    
    @MainActor
    func loadInitialImages() async {
        guard case .idle = state else { return }
        
        state = .loading(nil)
        await loadImages()
    }
    
    @MainActor
    func loadNextPageIfNeeded() async {
        guard canLoadMore, !isLoading,
              case .loaded(let images) = state else { return }
        
        state = .loading(images)
        await loadImages()
    }
    
    @MainActor
    private func loadImages() async {
        isLoading = true
        do {
            let newImages = try await unsplashService.getPhotos(
                page: currentPage,
                perPage: imagesPerPage
            )
            
            currentPage += 1
            canLoadMore = !newImages.isEmpty
            
            if case .loading(let existingImages?) = state {
                state = .loaded(existingImages + newImages)
            } else {
                state = .loaded(newImages)
            }
            
        } catch {
            print("Error: \(error.localizedDescription)")
            if case .loading(let existingImages) = state {
                state = .error(error, existingImages)
            } else {
                state = .error(error, nil)
            }
            canLoadMore = false
        }
        isLoading = false
    }
}
