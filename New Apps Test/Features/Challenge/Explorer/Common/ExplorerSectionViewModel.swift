//
//  ExplorerSectionViewModel.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 19/12/2024.
//

protocol ExplorerSectionViewModel {
    var state: GalleryState { get }
    var canLoadMore: Bool { get }
    
    func loadInitialImages() async
    func loadNextPageIfNeeded() async
}
