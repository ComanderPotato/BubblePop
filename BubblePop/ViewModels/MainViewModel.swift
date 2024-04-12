//
//  MainViewViewModel.swift
//  BubblePop
//
//  Created by Tom Golding on 28/3/2024.
//

import Foundation
import FirebaseAuth

class MainViewModel: ObservableObject {
    @Published var currentUserId: String = ""
    @Published var gameStarting: Bool = false
    private var handler: AuthStateDidChangeListenerHandle?
    init() {
        self.handler = Auth.auth().addStateDidChangeListener{ [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUserId = user?.uid ?? ""
            }
        }
    }
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    func setGameStarting() {
        self.gameStarting = !self.gameStarting
    }
}
