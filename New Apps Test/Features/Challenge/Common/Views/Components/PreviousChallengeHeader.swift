//
//  PreviousChallengeHeader.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//

import SwiftUI

struct PreviousChallengeHeader: View {
    let challenge: Challenge
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("Challenge d'hier")
                    .font(.title3.bold())
                    .foregroundStyle(.primary)
                
                Text("· \(formatDate(challenge.startTimestamp))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                participationCount
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(challenge.title)
                    .font(.title2.bold())
                    .foregroundStyle(.primary)
                
                Text(challenge.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineSpacing(4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
    
    private var participationCount: some View {
        HStack(spacing: 4) {
            Image(systemName: "photo.stack.fill")
                .font(.subheadline)
            Text("259.8k")
                .font(.subheadline.bold())
        }
        .foregroundStyle(.secondary)
    }
    
    private func formatDate(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMMM"
        formatter.locale = Locale.current
        return formatter.string(from: date).capitalized
    }
}

#Preview {
    VStack {
        PreviousChallengeHeader(challenge: .mocked)
            .padding()
        Spacer()
    }
    .background(Color(.systemBackground))
}
