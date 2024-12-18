//
//  MasonryLayout.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//

import SwiftUI

struct MasonryLayout: Layout {
    let columns: Int
    let spacing: CGFloat

    struct MasonryCache {
        var sizes: [Int: CGSize] = [:]
    }

    func makeCache(subviews: Subviews) -> MasonryCache {
        MasonryCache()
    }

    func updateCache(_ cache: inout MasonryCache, subviews: Subviews) {
        if cache.sizes.count != subviews.count {
            cache.sizes.removeAll()
        }
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout MasonryCache) -> CGSize {
        let proposedWidth = proposal.width ?? UIScreen.main.bounds.width
        let columnWidth = (proposedWidth - (CGFloat(columns - 1) * spacing)) / CGFloat(columns)
        
        var columnHeights = Array(repeating: CGFloat.zero, count: columns)

        for (index, subview) in subviews.enumerated() {
            let size: CGSize
            if let cachedSize = cache.sizes[index] {
                size = cachedSize
            } else {
                size = subview.sizeThatFits(.init(width: columnWidth, height: nil))
                cache.sizes[index] = size
            }

            if let (colIndex, minHeight) = columnHeights.enumerated().min(by: { $0.element < $1.element }) {
                columnHeights[colIndex] = minHeight + size.height + spacing
            }
        }

        let totalHeight = columnHeights.max() ?? 0
        return CGSize(width: proposedWidth, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout MasonryCache) {
        let columnWidth = (bounds.width - (CGFloat(columns - 1) * spacing)) / CGFloat(columns)
        var columnHeights = Array(repeating: CGFloat.zero, count: columns)

        for (index, subview) in subviews.enumerated() {
            let size: CGSize
            if let cachedSize = cache.sizes[index] {
                size = cachedSize
            } else {
                size = subview.sizeThatFits(.init(width: columnWidth, height: nil))
                cache.sizes[index] = size
            }

            if let (colIndex, minHeight) = columnHeights.enumerated().min(by: { $0.element < $1.element }) {
                let x = CGFloat(colIndex) * (columnWidth + spacing)
                let y = minHeight
                subview.place(
                    at: CGPoint(x: x, y: y),
                    proposal: .init(width: columnWidth, height: size.height)
                )
                columnHeights[colIndex] = y + size.height + spacing
            }
        }
    }
}
