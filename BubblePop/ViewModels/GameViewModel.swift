//
//  GameViewViewModel.swift
//  BubblePop
//
//  Created by Tom Golding on 25/3/2024.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore
class GameViewModel: ObservableObject {
    @Published var timer: TimeInterval
    @Published var gameScore: Double
    @Published var previousBubble: BubbleView?
    @Published var multiplier: Double
    @Published var difficulty: Int
    init(timer: TimeInterval = 60, difficulty: Int = 0, gameScore: Double = 0, multiplier: Double = 1) {
        self.timer = timer
        self.gameScore = gameScore
        self.multiplier = multiplier
        self.difficulty = difficulty
    }
    
    func decrementTimer() -> Void {
        self.timer -= 1
    }
    func pauseTime() -> Void {
        self.timer = self.timer
    }
    
    func insertNewScore() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        var name: String = ""
        db.collection("users").document(userId).getDocument { (document, error) in
            if let document = document {
                let data = document.data()
                name = data!["name"] as? String ?? ""
                let newScore = Score(id: UUID().uuidString, userId: userId, name: name, score: self.gameScore)
                db.collection("scores")
                    .addDocument(data: newScore.asDictionary())
            } else {
                    
            }
        }
//        let newScore = Score(id: UUID().uuidString, userId: userId, name: name, score: gameScore)
//        db.collection("scores")
//            .addDocument(data: newScore.asDictionary())
            
        
    }
}
