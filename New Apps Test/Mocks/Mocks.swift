//
//  Mocks.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 17/12/2024.
//

import Foundation

extension Challenge {
    static var mocked: Challenge {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        guard let startDate = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: today),
              let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else {
            fatalError("Failed to create preview challenge - TODO: Handle error 😃")
        }
        
        return Challenge(
            id: UUID(),
            title: "Un poirier et un lavabo",
            description: "Réaliser un poirier devant un lavabo",
            startTimestamp: startDate.timeIntervalSince1970,
            endTimestamp: endDate.timeIntervalSince1970
        )
    }
}
