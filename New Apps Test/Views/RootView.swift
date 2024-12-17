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
    
    let challengeService = MockChallengeService()
    
    var body: some View {
        TabView {
            ChallengeView(viewModel: .init(challengeService: challengeService))
                .tabItem {
                    Image(systemName: "house")
                }

            FriendsView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                }
        }
    }
}

#Preview {
    RootView()
}
