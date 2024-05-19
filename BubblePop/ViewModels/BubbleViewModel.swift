//
//  BubbleViewViewModel.swift
//  BubblePop
//
//  Created by Tom Golding on 25/3/2024.
//

import Foundation
// Enum for the BubbleColors to make it easier to communicate with the SwiftUI Colors
enum BubbleColors: String {
    case black = "black"
    case blue = "blue"
    case red = "red"
    case pink = "pink"
    case green = "green"
    case nothing
}
// BubbleViewModel has all the functionality that the bubble should have.
class BubbleViewModel: ObservableObject {
    // These are all easily understandable so I won't comment on each one
    @Published private var scale: CGFloat = 0.5
    @Published var xCoord: CGFloat
    @Published var yCoord: CGFloat
    @Published var bubbleColor: BubbleColors = .nothing
    @Published var points: Double = 1
    var xVelocity: CGFloat
    var yVelocity: CGFloat
    // Helpful to compute the coordinates etc...
    var halfWidth: CGFloat
    var halfHeight: CGFloat
    var radius: CGFloat
    // MIN_RADIUS and MAX_RADIUS are constant variables that will be used to set the random radius or strict radius depending on difficulty
    private let MIN_RADIUS: Double = 15
    private let MAX_RADIUS: Double = 35
    // Takes the parentBoundingBox which is a CGRect type and difficulty
    init(parentBoundingBox: CGRect, difficulty: Int) {
        // Setting the halfWidth and halfWeight as half the total of both
        self.halfWidth = parentBoundingBox.width / 2
        self.halfHeight = parentBoundingBox.height / 2
        // Set radius to random if difficulty is > 0 else MAX_RADIUS
        self.radius = difficulty > 0 ?
            Double.random(in: max(MAX_RADIUS / CGFloat(difficulty + 1), MIN_RADIUS)...MAX_RADIUS) :
            MAX_RADIUS
        // Setting random coordinates to be within the bounds
        self.xCoord = Double.random(in: self.radius...(parentBoundingBox.width - self.radius))
        self.yCoord = Double.random(in: self.radius...(parentBoundingBox.height - self.radius))
        // Random velocities as well, if difficulty is 0, they don't move
        self.xVelocity = Double.random(in: -Double(difficulty)...Double(difficulty))
        self.yVelocity = Double.random(in: -Double(difficulty)...Double(difficulty))
        // Setting both points and bubbleColor using function
        (self.points, self.bubbleColor) = generateRandomBubble()
    }
    
    // Gets random bubble with a random number, and the percentage to get each one from the requirements
    func generateRandomBubble() -> (Double, BubbleColors) {
        let randomNumber: Int = Int.random(in: 0...100)
        switch(randomNumber) {
            case 0...5:
                return (10, .black)
            case 5...15:
                return (8, .blue)
            case 15...30:
                return (5, .green)
            case 30...60:
                return (2, .pink)
            default:
                return (1, .red)
        }
    }
    // Checks if a bubble has collided with a wall
    func collidedWithWall() -> Bool {
        return !(
            (xCoord > (halfWidth - halfWidth + self.radius)) &&
            (xCoord < (halfWidth + halfWidth - self.radius)) &&
            (yCoord > (halfHeight - halfHeight + self.radius)) &&
            (yCoord < (halfHeight + halfHeight - self.radius))
        )
    }
    // Changes the direction of the velocity
    func changeDirection() -> Void {
        if ((xCoord < halfWidth - halfWidth + self.radius) ||
            (xCoord >= halfWidth + halfWidth - self.radius)) {
            xVelocity *= -1;
        }
        if ((yCoord < halfHeight - halfHeight + self.radius) ||
            (yCoord >= halfHeight + halfHeight - self.radius)) {
            yVelocity *= -1;
        }
        
    }
    // Updates the bubbles coordinates with its velocities
    func updatePosition() -> Void {
        self.xCoord += self.xVelocity
        self.yCoord += self.yVelocity
    }
    // Checks if a bubble is intersecting with another bubble
    func intersects(other: BubbleView) -> Bool {
        let d = self.getDistance(other: other);
        return (d < self.radius + other.viewModel.radius);
    }
    // Gets the distance between two bubbles
    func getDistance(other: BubbleView) -> Double {
        let dx = other.viewModel.xCoord - self.xCoord;
        let dy = other.viewModel.yCoord - self.yCoord;
        return sqrt(dx * dx + dy * dy);
    }
}
