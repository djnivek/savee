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
    case today
}

struct MosaicSegmentedDemo: View {
    @State private var selectedType: MosaicType = .global
    
    private let items: [(value: MosaicType, title: String)] = [
        (.today, "Aujourd'hui"),
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
            
            switch selectedType {
            case .global:
                Text("Vue Globale")
            case .friends:
                Text("Vue Amis")
            case .today:
                Text("Challenge du Jour")
            }
        }
    }
}

#Preview {
    MosaicSegmentedDemo()
}
