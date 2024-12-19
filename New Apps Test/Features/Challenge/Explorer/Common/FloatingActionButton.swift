//
//  FloatingActionButton.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 19/12/2024.
//


import SwiftUI

struct FloatingActionButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "info.circle.fill")
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(Color.accentColor)
                .clipShape(Circle())
                .shadow(radius: 4, y: 4)
        }
        .padding(24)
    }
}