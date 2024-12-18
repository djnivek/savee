//
//  CustomSegmentItem.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//

import SwiftUI

struct CustomSegmentItem<Value: Hashable> {
    let label: any View
    let value: Value
    
    init(title: String, value: Value) {
        self.label = Text(title)
        self.value = value
    }
}
