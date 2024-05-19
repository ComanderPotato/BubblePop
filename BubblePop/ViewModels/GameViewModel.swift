//
//  GameViewViewModel.swift
//  BubblePop
//
//  Created by Tom Golding on 25/3/2024.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI
// GameViewModel is the main model used when in the gameview, holds all the functionality that the game needs
class GameViewModel: ObservableObject {
    // gameTime and countDownTimer are for the visible times, once countdown is at 0 it is replaced with gametime
    @Published var gameTime: TimeInterval
    @Published var countDownTime: TimeInterval = 3
    // Keeps track of the game score
    @Published var gameScore: Double = 0
    // Keeps track of the previous bubble
    @Published var previousBubbleColor: BubbleColors = .nothing
    // Keeps track of the multiplier
    @Published var multiplier: Double = 1
    @Published var difficulty: Int
    // Holds all the bubbles that are displayed on the game screen
    @Published var bubbles: [BubbleView] = []
    // A timer class I made to hold the timer functionality
    @Published var gameTimer: TimerViewModel
    @Published var bubbleViewModel: BubbleViewModel?
    var numberOfBubbles: Int
    private var parentBoundingBox: CGRect = CGRect()
    private var timer: Timer?
    
    
    @Published var user: User?
    private var handler: AuthStateDidChangeListenerHandle?
    init(gameTime: TimeInterval, numberOfBubbles: Int, difficulty: Int) {
        self.gameTime = gameTime
        self.difficulty = difficulty
        self.numberOfBubbles = numberOfBubbles
        self.gameTimer = TimerViewModel(totalTime: gameTime)
        self.fetchUser()
    }
    
    /* GETTERS AND SETTERS  */
    func setParentBoundingBox(parentBoundingBox: CGRect) -> Void {
        self.parentBoundingBox = parentBoundingBox
    }
    func setBubbleViewModel(parentBoundingBox: CGRect) -> Void {
        self.bubbleViewModel = BubbleViewModel(parentBoundingBox: parentBoundingBox, difficulty: self.difficulty)
        
    }
    func getGameTime() -> TimeInterval {
        return self.gameTime
    }
    func getCountDownTime() -> TimeInterval {
        return self.countDownTime
    }
    func getGameScore() -> Double {
        return self.gameScore
    }
    func getPreviousBubbleColor() -> BubbleColors {
        return self.previousBubbleColor
    }
    func setPreviousBubbleColor(currentBubbleColor: BubbleColors) -> Void {
        self.previousBubbleColor = currentBubbleColor
    }
    func setMultiplier(currentBubbleColor: BubbleColors) {
        self.multiplier = (self.previousBubbleColor == currentBubbleColor) ? 1.5 : 1.0
    }
    func updateGameScore(bubblePoints: Double) -> Void {
        self.gameScore += (bubblePoints * self.multiplier)
    }
    
    /* ANIMATION FUNCTIONS */
    // Used to animate and stop animating the bubbles
    func startAnimating() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            self.updateBubblePositions()
        }
    }
    func stopAnimating() {
        self.timer?.invalidate()
    }
    
    /* TIMER FUNCTIONS */
    func toggleIsActive() -> Void {
        gameTimer.toggleIsActive()
        objectWillChange.send()
    }
    func isGameTimerActive() -> Bool {
        return gameTimer.isActive
    }
    func decrementGameTime() -> Void {
        guard self.isGameTimerActive() else {
            return
        }
        self.gameTime -= 1
    }
    func decrementCountDownTime() -> Void {
        self.countDownTime -= 1
    }
    func pauseTime() -> Void {
        self.gameTime = self.gameTime
    }
    
    /* BUBBLE FUNCTIONS */
    // Generates a random array of bubbles to be displayed on the screen, checks if it intersects before adding it or not
    func generateBubbles() -> Void {
        let randomBubbleCount = Int.random(in: (bubbles.isEmpty ? self.numberOfBubbles / 2 : self.bubbles.count)...self.numberOfBubbles)
        while bubbles.count < randomBubbleCount {
            
            let newBubble = BubbleView(viewModel: .init(parentBoundingBox: self.parentBoundingBox, difficulty: self.difficulty)) 
            
            if !checkIfIntersects(bubble: newBubble) {
                self.bubbles.append(newBubble)
            }
        }
    }
    // Removes random amount of bubbles between a certain amount, triggered every second
    func removeRandomBubbles() -> Void {
        if self.bubbles.isEmpty {
            return;
        }
        let randomNumber = Int.random(in: 0...(self.bubbles.count / 2))
    
        for _ in 0...randomNumber {
            self.bubbles.removeLast();
        }
                
    }
    // Used to check if a bubble intersects with another bubble in the array
    func checkIfIntersects(bubble: BubbleView) -> Bool {
        for other in self.bubbles {
            if bubble.id != other.id {
                if bubble.viewModel.intersects(other: other) {
                    return true
                }
            }
        }
        return false
    }
    // Empties bubble array
    func clearBubbles() -> Void {
        self.bubbles = [];
    }
    // Updates the bubbles position on the game screen
    private func updateBubblePositions() {
        for bubble in bubbles {
            if bubble.viewModel.collidedWithWall() {
                bubble.viewModel.changeDirection()
            }
            bubble.viewModel.updatePosition()
        }
    }
    // Removes bubble at a given index
    func removeBubble(indexToRemove: Int) {
        self.bubbles.remove(at: indexToRemove)
    }
    // Creates and appends a new bubble to array
    func appendBubble() {
        let newBubble = BubbleView(viewModel: .init(parentBoundingBox: self.parentBoundingBox, difficulty: self.difficulty))
        self.bubbles.append(newBubble)
    }
    /* DATABASE FUNCTIONS */
    // Inserts a new score into the leaderboard using FireBase
    func insertNewScore() {
        guard let currentUser = self.user else {
            return
        }
        self.updateHighScore(currentUser: currentUser)
        let db = Firestore.firestore()
        let newId = UUID().uuidString
        let newScore = Score(
            id: UUID().uuidString,
            userId: currentUser.id,
            name: currentUser.name,
            score: self.gameScore)
        db.collection("scores")
            .document(newId)
            .setData(newScore.asDictionary())
    }
    // Updates the users high score if the current gameScore is larger then the users highscore
    func updateHighScore(currentUser: User) -> Void {
        guard self.gameScore > currentUser.highScore else {
            return
        }
        let db = Firestore.firestore()
        db.collection("users")
            .document(currentUser.id)
            .updateData(["highScore": self.gameScore])
    }
    // Retrieves the current user from the Firestore database
    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
                self?.user = User(
                    id: data["id"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    highScore: data["highScore"] as? Double ?? 0.0,
                    joined: data["joined"] as? TimeInterval ?? 0)
        }
    }
}
