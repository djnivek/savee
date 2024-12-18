//
//  CircleGalleryViewModel.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//

import Foundation

@Observable
final class CircleGalleryViewModel: GalleryViewModel {
    private let unsplashService: UnsplashService
    private var currentPage = 1
    private let imagesPerPage = 30
    private var isLoading = false
    
    var state: GalleryState = .idle
    var canLoadMore = true
    
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
            let newImages = try await unsplashService.getCirclePhotos(
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
