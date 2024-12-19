//
//  CircleView.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//

import SwiftUI

struct CircleView: View {
    let viewModel: CircleGalleryViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                content
            }
            .padding()
        }
        .refreshable {
            await viewModel.loadInitialImages()
        }
        .task {
            await viewModel.loadInitialImages()
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading(nil):
            loadingView
            
        case .loading(let images?):
            existingImagesGrid(images)
            loadingView
            
        case .loaded(let images):
            if images.isEmpty {
                emptyView
            } else {
                existingImagesGrid(images)
            }
            
        case .error(let error, let images):
            if let images, !images.isEmpty {
                existingImagesGrid(images)
            }
            errorView(error)
        }
    }
    
    private func existingImagesGrid(_ images: [UnsplashImage]) -> some View {
        ForEach(images) { image in
            CircleDetailCardView(image: image)
                .transition(.opacity)
        }
    }
    
    private var loadingView: some View {
        ProgressView()
            .scaleEffect(1.5)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
    }
    
    private var emptyView: some View {
        ContentUnavailableView(
            "No photos",
            systemImage: "photo.stack",
            description: Text("Your circle hasn't shared any photos yet")
        )
        .padding(.vertical, 32)
    }
    
    private func errorView(_ error: Error) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.red)
            
            Text(error.localizedDescription)
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            
            Button("Try again") {
                Task {
                    await viewModel.loadInitialImages()
                }
            }
            .buttonStyle(.bordered)
        }
        .padding(.vertical, 32)
        .frame(maxWidth: .infinity)
    }
}
