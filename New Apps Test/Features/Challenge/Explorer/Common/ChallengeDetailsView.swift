//
//  ChallengeDetailsView.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 19/12/2024.
//


import SwiftUI

struct ChallengeDetailsView: View {
    let challenge: Challenge
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text(challenge.title)
                    .font(.title2.bold())
                
                Text(formatDate(challenge.startTimestamp))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Description")
                    .font(.headline)
                Text(challenge.description)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Image(systemName: "photo.stack.fill")
                    .font(.title3)
                Text("259.8k participants")
                    .font(.headline)
            }
            .foregroundStyle(.secondary)
            
            Spacer()
        }
        .padding()
    }
    
    private func formatDate(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMMM"
        formatter.locale = Locale.current
        return formatter.string(from: date).capitalized
    }
}
