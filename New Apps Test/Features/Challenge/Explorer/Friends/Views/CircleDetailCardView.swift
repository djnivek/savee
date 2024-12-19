//
//  CircleDetailCardView.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 19/12/2024.
//


import SwiftUI

struct CircleDetailCardView: View {
    let image: UnsplashImage
    @State private var isLiked = false
    @State private var isReacted = false

    private let hapticManager = HapticManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(image.user.name)
                        .font(.headline)
                    
                    Text("@\(image.user.username)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            if let url = URL(string: image.urls.regular) {
                CachedAsyncImage(url: url) {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }

            HStack(spacing: 24) {
                reactionButton(icon: "heart.fill", text:"18 loves", color: .red, isSelected: $isLiked)
                reactionButton(icon: "face.smiling.fill", text:"42 smiles", color: .yellow, isSelected: $isReacted)
                Spacer()
            }
            .padding(.top, 8)
        }
        .padding()
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isLiked)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isReacted)
    }

    @ViewBuilder
    private func reactionButton(icon: String, text: String, color: Color, isSelected: Binding<Bool>) -> some View {
        Button {
            withAnimation {
                isSelected.wrappedValue.toggle()
            }
            
            hapticManager.playImpact(intensity: isSelected.wrappedValue ? 0.7 : 0.3)
        } label: {
            Label {
                Text(text)
            } icon: {
                if #available(iOS 18.0, *) {
                    Image(systemName: isSelected.wrappedValue ? icon : icon.replacingOccurrences(of: ".fill", with: ""))
                        .font(.title2)
                        .foregroundStyle(isSelected.wrappedValue ? color : .secondary)
                        .scaleEffect(isSelected.wrappedValue ? 1.4 : 1)
                        .symbolEffect(.bounce.up.byLayer, options: isSelected.wrappedValue ? .repeating : .nonRepeating)
                } else {
                    Image(systemName: isSelected.wrappedValue ? icon : icon.replacingOccurrences(of: ".fill", with: ""))
                        .font(.title2)
                        .foregroundStyle(isSelected.wrappedValue ? color : .secondary)
                        .scaleEffect(isSelected.wrappedValue ? 1.4 : 1)
                        .rotationEffect(isSelected.wrappedValue ? .degrees(15) : .degrees(0))
                        .animation(.easeInOut(duration: 0.2), value: isSelected.wrappedValue)
                }
            }
        }
        .buttonStyle(.plain)
    }
}



