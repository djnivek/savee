//
//  PolaroidFrame.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//

import Foundation

struct PolaroidFrame: Identifiable {
    let id = UUID()
    let index: Int
    let angle: Double
    let rotationOffset: Double
    let scaleOffset: Double
    
    static func createFrames(count: Int) -> [PolaroidFrame] {
        (0..<count).map { i in
            PolaroidFrame(
                index: i,
                angle: Double(i) * (360.0 / Double(count)),
                rotationOffset: Double.random(in: -15...15),
                scaleOffset: Double.random(in: 0.85...1.10)
            )
        }
    }
}
