//
//  SuccessView.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 19/12/2024.
//

import SwiftUI

private struct SuccessView: View {
    @State private var showConfetti = false
    
    var body: some View {
        ZStack {
            VStack {
                Text("Défi Réussi !")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Button(action: {
                    withAnimation {
                        showConfetti = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            showConfetti = false
                        }
                    }
                }) {
                    Text("Fêter !")
                        .font(.headline)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            
            if showConfetti {
                ConfettiFallView(isActive: $showConfetti)
            }
        }
    }
}

#Preview {
    SuccessView()
}
