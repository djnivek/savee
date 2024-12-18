//
//  MosaicType.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//


import SwiftUI

enum MosaicType: Hashable {
    case global
    case friends
}

struct MosaicSegmentedDemo: View {
    @State private var selectedType: MosaicType = .global
    
    private let items: [(value: MosaicType, title: String)] = [
        (.global, "Global"),
        (.friends, "Amis")
    ]
    
    var body: some View {
        VStack {
            CustomSegmentedControl(
                items: items,
                selection: $selectedType
            )
            .padding()
            
            Text(selectedType == .global ? "Vue Globale" : "Vue Amis")
                .font(.title)
                .frame(maxHeight: .infinity)
        }
    }
}

#Preview {
    MosaicSegmentedDemo()
}
