//
//  MosaicView.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//

import SwiftUI

struct DiscoverView: View {
    let viewModel: DiscoverGalleryViewModel
    var body: some View {
        GalleryView(viewModel: viewModel)
    }
}

#Preview {
    DiscoverView(
        viewModel: .init(
            unsplashService: UnsplashService()
        )
    )
}
