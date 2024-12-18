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
        GalleryView(viewModel: viewModel)
    }
}
