//
//  RootView.swift
//  New Apps Test
//
//  Created by Michel-Andre Chirita on 28/06/2024.
//

/*
 --------------------------------------------------
 -- Voodoo New Apps Tech Test
 -- BOOSTRAP FILE
 -- Feel free to modify or dismiss it as you like !
 --------------------------------------------------
 */

import SwiftUI

struct RootView: View {
    @State private var selectedTab: Tab = .challenge
    private let challengeService = MockChallengeService()
    private let hapticManager = HapticManager.shared
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                TodayChallengeView(
                    viewModel: .init(challengeService: challengeService),
                    hapticManager: hapticManager
                )
                .navigationTitle("Hoost")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink {
                            SettingsView()
                        } label: {
                            Image(systemName: "gearshape.circle")
                                .font(.title2)
                                .foregroundStyle(.primary)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            FriendsView()
                        } label: {
                            Image(systemName: "person.2.circle")
                                .font(.title2)
                                .foregroundStyle(.primary)
                        }
                    }
                }
            }
            .tabItem {
                Label(Tab.challenge.title, systemImage: Tab.challenge.icon)
            }
            .tag(Tab.challenge)
            
            NavigationStack {
                ExplorerView()
                    .navigationTitle("Hoost")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            NavigationLink {
                                SettingsView()
                            } label: {
                                Image(systemName: "gearshape.circle")
                                    .font(.title2)
                                    .foregroundStyle(.primary)
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink {
                                FriendsView()
                            } label: {
                                Image(systemName: "person.2.circle")
                                    .font(.title2)
                                    .foregroundStyle(.primary)
                            }
                        }
                    }
            }
            .tabItem {
                Label(Tab.explorer.title, systemImage: Tab.explorer.icon)
            }
            .tag(Tab.explorer)
        }
    }
}

#Preview {
    RootView()
}
