//
//  BubbleViewViewModel.swift
//  BubblePop
//
//  Created by Tom Golding on 25/3/2024.
//

import Foundation

//enum BubbleColor {
//    case red
//    case pink
//    case green
//    case blue
//    case black
//    case nothing
//}
class BubbleViewModel: ObservableObject {
    @Published var bubbles: [String : BubbleView] = [:]
    private var parentBoundingBox: CGRect = CGRect()
    private var timer: Timer?
    private var difficulty: Int = 0

    init() {}
    
    func setParameters(parentBoundingBox: CGRect, difficulty: Int) -> Void {
        self.parentBoundingBox = parentBoundingBox
        self.difficulty = difficulty
    }
    func generateBubbles(numberOfBubbles: Int) -> Void {
        bubbles = [:]
        for _ in 0..<numberOfBubbles {
            let newBubble = BubbleView(parentBoundingBox: self.parentBoundingBox, difficulty: self.difficulty)
            if !checkIfIntersects(bubble: newBubble) {
                bubbles.updateValue(newBubble, forKey: newBubble.id)
            }
        }
    }
    func checkIfIntersects(bubble: BubbleView) -> Bool {
        for (key, value) in bubbles {
            if !(key == bubble.id) {
                if bubble.intersects(other: value) {
                    return true
                }
            }
        }
        return false
    }
    func startAnimating() {
            // Invalidate the previous timer, if any
            timer?.invalidate()

            // Create and schedule a new timer
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                // Update the positions of bubbles
                self.updateBubblePositions()
            }
        }
    func stopAnimating() {
        timer?.invalidate()
    }
    private func updateBubblePositions() {
        
        for (key, value) in bubbles {
            if bubbles[key]!.collidedWithWall() {
                bubbles[key]!.changeDirection()
            }
            bubbles[key]!.xCoord += bubbles[key]!.xVelocity
            bubbles[key]!.yCoord += bubbles[key]!.yVelocity
        }
//        for index in bubbles.indices {
//            if bubbles[index].collidedWithWall() {
//                bubbles[index].changeDirection()
//            }
//            bubbles[index].xCoord += bubbles[index].xVelocity
//            bubbles[index].yCoord += bubbles[index].yVelocity
//        }
        objectWillChange.send()
    }
    func removeBubble(id: String) {
        bubbles.removeValue(forKey: id)
    }
    func appendBubble() {
        let newBubble = BubbleView(parentBoundingBox: self.parentBoundingBox, difficulty: self.difficulty)
        bubbles.updateValue(newBubble, forKey: newBubble.id)
    }
}

