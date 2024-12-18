//
//  ExplorerView.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//


import SwiftUI

struct ExplorerView: View {
    @State private var selectedSection: ExplorerSection = .discover
    private let unsplashService = UnsplashService()
    
    var body: some View {
        VStack(spacing: 0) {
            CustomSegmentedControl(
                items: [
                    (.discover, ExplorerSection.discover.title),
                    (.circle, ExplorerSection.circle.title)
                ],
                selection: $selectedSection
            )
            .padding(.horizontal)
            
            TabView(selection: $selectedSection) {
                DiscoverView(viewModel: .init(unsplashService: unsplashService))
                    .tag(ExplorerSection.discover)
                
                DiscoverView(viewModel: .init(unsplashService: unsplashService))
                    .tag(ExplorerSection.circle)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}
