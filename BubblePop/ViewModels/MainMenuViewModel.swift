//
//  MainMenuViewModel.swift
//  BubblePop
//
//  Created by Tom Golding on 4/4/2024.
//

import Foundation

class MainMenuViewModel: ObservableObject {
    @Published var gameStarting: Bool = false
    init() {
    }
    func setGameStarting() {
        self.gameStarting = !self.gameStarting
    }
}
