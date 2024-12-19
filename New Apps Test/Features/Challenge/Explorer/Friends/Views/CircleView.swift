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
                switch viewModel.state {
                case .loading:
                    ProgressView()
                        .scaleEffect(1.5)
                    
                case .loaded(let images):
                    ForEach(images, id: \.id) { image in
                        CircleDetailCardView(image: image)
                    }
                    
                case .error(let error, _):
                    ErrorView {
                        await viewModel.loadInitialImages()
                    }
                    .alert("Erreur", isPresented: .constant(true)) {
                        Text(error.localizedDescription)
                    }
                    
                default:
                    Text("Pas d'images à afficher pour le moment.")
                }
            }
            .padding()
        }
        .task {
            await viewModel.loadInitialImages()
        }
    }
}
