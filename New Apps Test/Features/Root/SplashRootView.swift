//
//  SplashRootView.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 19/12/2024.
//


import SwiftUI

@MainActor
final class SplashViewModel: ObservableObject {
    enum TransitionPhase {
        case initial
        case transition
        case completed
    }
    
    @Published var phase: TransitionPhase = .initial
    
    func startTransition() async {
        phase = .transition
        
        try? await Task.sleep(for: .seconds(1.2))
        phase = .completed
    }
}

struct SplashRootView: View {
    @StateObject private var viewModel = SplashViewModel()
    @State private var shouldShowSplash = true
    
    var body: some View {
        ZStack {
            RootView()
                .opacity(viewModel.phase == .initial ? 0 : 1)
            
            if shouldShowSplash {
                PolaroidCircleView(hapticManager: HapticManager.shared) {
                    Task {
                        await viewModel.startTransition()
                    }
                }
                .transition(.opacity)
            }
        }
        .onChange(of: viewModel.phase) { _, newPhase in
            if newPhase == .completed {
                withAnimation(.easeOut(duration: 0.3)) {
                    shouldShowSplash = false
                }
            }
        }
    }
}

#Preview {
    SplashRootView()
}
