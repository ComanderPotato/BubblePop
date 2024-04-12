//
//  Users.swift
//  BubblePop
//
//  Created by Tom Golding on 28/3/2024.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let email: String
    let origin: String
    let highScore: Double
    let joined: TimeInterval
}
