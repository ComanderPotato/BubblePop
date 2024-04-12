//
//  HighScore.swift
//  BubblePop
//
//  Created by Tom Golding on 28/3/2024.
//

import Foundation

struct Score: Codable, Identifiable {
    let id: String
    let userId: String
    let name: String
    let score: Double
}
