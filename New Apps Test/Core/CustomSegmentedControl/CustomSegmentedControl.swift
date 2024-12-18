//
//  CustomSegmentedControl.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//


import SwiftUI

struct CustomSegmentedControl<SelectionValue: Hashable, Label: View>: View {
    let items: [(value: SelectionValue, label: Label)]
    @Binding var selection: SelectionValue
    private let hapticManager: HapticManaging
    
    init(
        items: [(value: SelectionValue, label: Label)],
        selection: Binding<SelectionValue>,
        hapticManager: HapticManaging = HapticManager.shared
    ) {
        self.items = items
        self._selection = selection
        self.hapticManager = hapticManager
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selection = item.value
                    }
                    hapticManager.playImpact(intensity: 0.4)
                } label: {
                    VStack(spacing: 2) {
                        item.label
                            .font(.headline)
                        
                        if selection == item.value {
                            RoundedRectangle(cornerRadius: 2)
                                .frame(width: 24, height: 4)
                                .foregroundStyle(.tint)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(selection == item.value ? .primary : .secondary)
                    .contentShape(Rectangle())
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

extension CustomSegmentedControl where Label == Text {
    init(
        items: [(value: SelectionValue, title: String)],
        selection: Binding<SelectionValue>,
        hapticManager: HapticManaging = HapticManager.shared
    ) {
        self.init(
            items: items.map { (value: $0.value, label: Text($0.title)) },
            selection: selection,
            hapticManager: hapticManager
        )
    }
}
