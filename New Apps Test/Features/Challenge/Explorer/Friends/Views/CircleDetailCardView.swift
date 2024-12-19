//
//  CircleDetailCardView.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 19/12/2024.
//

import SwiftUI

struct CircleDetailCardView: View {
    let image: UnsplashImage
    
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var isLiked = false
    @State private var isReacted = false
    @State private var isImageLoaded = false
    
    private let hapticManager = HapticManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            imageContent
            reactions
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isLiked)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isReacted)
        .animation(.easeInOut, value: isImageLoaded)
        .cardStyle()
    }
    
    private var header: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(image.user.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text("@\(image.user.username)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer(minLength: 0)
            
            Menu {
                Button(role: .none) {
                    // Action
                } label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                
                Button(role: .none) {
                    // Action
                } label: {
                    Label("Report", systemImage: "exclamationmark.triangle")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
        }
    }
    
    private var imageContent: some View {
        Group {
            if let url = URL(string: image.urls.regular) {
                CachedAsyncImage(url: url) {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .frame(height: dynamicImageHeight)
                }
                .onAppear { isImageLoaded = true }
                .onDisappear { isImageLoaded = false }
            }
        }
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .opacity(isImageLoaded ? 1 : 0)
    }
    
    private var reactions: some View {
        HStack(spacing: 24) {
            reactionButton(
                icon: "heart",
                text: "18 loves",
                color: .red,
                isSelected: $isLiked
            )
            
            reactionButton(
                icon: "face.smiling",
                text: "42 smiles",
                color: .yellow,
                isSelected: $isReacted
            )
            
            Spacer(minLength: 0)
        }
        .padding(.top, 8)
    }
    
    private func reactionButton(
        icon: String,
        text: String,
        color: Color,
        isSelected: Binding<Bool>
    ) -> some View {
        Button {
            isSelected.wrappedValue.toggle()
            hapticManager.playImpact(intensity: isSelected.wrappedValue ? 0.7 : 0.3)
        } label: {
            Label {
                Text(text)
                    .lineLimit(1)
            } icon: {
                Image(systemName: isSelected.wrappedValue ? "\(icon).fill" : icon)
                    .font(.title2)
                    .foregroundStyle(isSelected.wrappedValue ? color : .secondary)
                    .scaleEffect(isSelected.wrappedValue ? 1.4 : 1)
                    .symbolEffect(
                        .bounce.up.byLayer,
                        options: .nonRepeating,
                        value: isSelected.wrappedValue
                    )
            }
            .contentTransition(.symbolEffect(.automatic))
        }
        .buttonStyle(.plain)
    }
    
    private var dynamicImageHeight: CGFloat {
        switch dynamicTypeSize {
        case .xSmall, .small:
            return 300
        case .medium:
            return 280
        case .large:
            return 260
        case .xLarge:
            return 240
        case .xxLarge:
            return 220
        case .xxxLarge:
            return 200
        default:
            return 280
        }
    }
}



