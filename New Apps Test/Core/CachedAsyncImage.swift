//
//  CachedAsyncImage.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//

import SwiftUI
import Combine

class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSURL, UIImage>()
    
    func image(for url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }
    
    func store(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}

struct CachedAsyncImage<Placeholder: View>: View {
    let url: URL
    let placeholder: Placeholder
    
    @State private var cachedImage: UIImage?
    @State private var isDownloading = false
    
    init(url: URL, @ViewBuilder placeholder: () -> Placeholder) {
        self.url = url
        self.placeholder = placeholder()
    }
    
    var body: some View {
        Group {
            if let cached = cachedImage {
                Image(uiImage: cached)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            } else {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        placeholder
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .onAppear {
                                cacheImage()
                            }
                    case .failure:
                        placeholder
                    @unknown default:
                        placeholder
                    }
                }
                .onAppear {
                    if let cached = ImageCache.shared.image(for: url) {
                        cachedImage = cached
                    }
                }
            }
        }
    }
    
    private func cacheImage() {
        guard !isDownloading else { return }
        isDownloading = true
        
        if let cached = ImageCache.shared.image(for: url) {
            self.cachedImage = cached
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data,
                  let uiImage = UIImage(data: data) else {
                return
            }
            ImageCache.shared.store(uiImage, for: url)
            DispatchQueue.main.async {
                self.cachedImage = uiImage
            }
        }.resume()
    }
}
