//
//  InfiniteScrollModifier.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//

import SwiftUI

struct InfiniteScrollModifier: ViewModifier {
    let threshold: CGFloat
    let action: () async -> Void
    
    init(threshold: CGFloat = 50, action: @escaping () async -> Void) {
        self.threshold = threshold
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: ScrollViewPositionKey.self,
                        value: geometry.frame(in: .global).maxY
                    )
                }
            )
            .onPreferenceChange(ScrollViewPositionKey.self) { maxY in
                guard let maxY else { return }
                
                let height = UIScreen.main.bounds.height
                let threshold = height + self.threshold
                
                if maxY < threshold {
                    Task {
                        await action()
                    }
                }
            }
    }
}

private struct ScrollViewPositionKey: PreferenceKey {
    static var defaultValue: CGFloat?
    
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        if let next = nextValue() {
            value = next
        }
    }
}

extension View {
    func infiniteScroll(
        threshold: CGFloat = 50,
        action: @escaping () async -> Void
    ) -> some View {
        modifier(InfiniteScrollModifier(threshold: threshold, action: action))
    }
}
