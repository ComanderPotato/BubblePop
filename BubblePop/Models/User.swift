//
//  Users.swift
//  BubblePop
//
//  Created by Tom Golding on 28/3/2024.
//

import Foundation
// User class
struct User: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
    let highScore: Double
    let joined: TimeInterval
}
