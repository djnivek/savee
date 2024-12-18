//
//  GalleryView.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//

import SwiftUI

struct GalleryView<ViewModel: GalleryViewModel>: View {
    @State private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            MasonryLayout(columns: 3, spacing: 2) {
                content
            }
            .padding(2)
            .infiniteScroll {
                if viewModel.canLoadMore {
                    await viewModel.loadNextPageIfNeeded()
                }
            }
        }
        .task {
            await viewModel.loadInitialImages()
        }
        .refreshable {
            await viewModel.loadInitialImages()
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            EmptyView()
            
        case .loading(let images?):
            existingImagesGrid(images)
            loadingIndicator
            
        case .loading(nil):
            loadingIndicator
            
        case .loaded(let images):
            existingImagesGrid(images)
            
            if viewModel.canLoadMore {
                loadingIndicator
            }
            
        case .error(let error, let images?):
            existingImagesGrid(images)
            errorView(error)
            
        case .error(let error, nil):
            errorView(error)
        }
    }
    
    private func existingImagesGrid(_ images: [UnsplashImage]) -> some View {
        ForEach(images) { image in
            if let url = URL(string: image.urls.thumb) {
                ImageCell(url: url)
            }
        }
    }
    
    private var loadingIndicator: some View {
        ProgressView()
            .frame(maxWidth: .infinity)
            .padding()
    }
    
    private func errorView(_ error: Error) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle")
                .font(.title)
                .foregroundStyle(.red)
            Text(error.localizedDescription)
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

private struct ImageCell: View {
    let url: URL
    
    var body: some View {
        CachedAsyncImage(url: url) {
            ProgressView()
        }
        .frame(height: 120)
        .aspectRatio(contentMode: .fill)
        .clipShape(.rect(cornerRadius: 8))
    }
}
