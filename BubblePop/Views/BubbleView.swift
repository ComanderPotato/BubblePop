//
//  BubbleView.swift
//  BubblePop
//
//  Created by Tom Golding on 25/3/2024.
//

import SwiftUI
enum BubbleColor {
    case black
    case blue
    case green
    case pink
    case red
}

// View, Identifiable
// id = UUID().uuidString

struct BubbleView: View {
    @State private var scale: CGFloat = 0.5
    let id: String
    var color: Color =  .red
    var points: Double = 0
    var xCoord: CGFloat
    var yCoord: CGFloat
    var xVelocity: CGFloat = 0
    var yVelocity: CGFloat = 0
    var halfWidth: CGFloat = 0
    var halfHeight: CGFloat = 0
    var centerX: CGFloat = 0
    var centerY: CGFloat = 0
    var radius: CGFloat = 35
    var difficulty: Double = 0.0
    init(parentBoundingBox: CGRect, difficulty: Int) {
        self.id = UUID().uuidString
        self.halfWidth = parentBoundingBox.width / 2
        self.halfHeight = parentBoundingBox.height / 2
        self.centerX = halfWidth
        self.centerY = halfHeight
        self.radius = difficulty > 0 ?
        Double.random(in: max(self.radius / CGFloat(difficulty + 1), 15)...self.radius) : 35
        self.xCoord = Double.random(in: self.radius...(parentBoundingBox.width - self.radius))
        self.yCoord = Double.random(in: self.radius...(parentBoundingBox.height - self.radius))
        self.difficulty = Double(difficulty)
        self.xVelocity = Double.random(in: -self.difficulty...self.difficulty)
        self.yVelocity = Double.random(in: -self.difficulty...self.difficulty)
        self.color = generateRandomBubble()
    }
    mutating func generateRandomBubble() -> Color {
        let randomNumber: Int = Int.random(in: 0...100)
        switch(randomNumber) {
            case 0...5:
                self.points = 10
                return .black
            case 5...15:
                self.points = 8
                return .blue
            case 15...30:
                self.points = 5
                return .green
            case 30...60:
                self.points = 2
                return .pink
            default:
                self.points = 1
                return .red
        }
    }
    func collidedWithWall() -> Bool {
        return !(
            (xCoord > (centerX - halfWidth + self.radius)) &&
            (xCoord < (centerX + halfWidth - self.radius)) &&
            (yCoord > (centerY - halfHeight + self.radius)) &&
            (yCoord < (centerY + halfHeight - self.radius))
        )
    }
    mutating func changeDirection() -> Void {
        if ((xCoord < centerX - halfWidth + self.radius) ||
            (xCoord >= centerX + halfWidth - self.radius)) {
            xVelocity *= -1;
        }
        if ((yCoord < centerY - halfHeight + self.radius) ||
            (yCoord >= centerY + halfHeight - self.radius)) {
            yVelocity *= -1;
        }
        
    }
   
    func intersects(other: BubbleView) -> Bool {
        let d = self.getDistance(other: other);
        return (d < self.radius + other.radius);
    }
    func getDistance(other: BubbleView) -> Double {
        let dx = other.xCoord - self.xCoord;
        let dy = other.yCoord - self.yCoord;

        return sqrt(dx * dx + dy * dy);
    }
    var body: some View {
        Circle()
            .shadow(color: color, radius: 5)
            .foregroundStyle(color)
            .frame(width: self.radius * 2, height: self.radius * 2)
            .position(x: xCoord, y: yCoord )
            .scaleEffect(1)
//            .onAppear {
//                    let baseAnimation = Animation.easeInOut(duration: 1)
//                    withAnimation(baseAnimation) {
//                        self.scale = 1
//                    }
//                }
//            .onDisappear(perform: {
//                let baseAnimation = Animation.easeInOut(duration: 1)
//                withAnimation(baseAnimation) {
//                    self.scale = 0
//                }
//            })
//            
            
        
    }
}

#Preview {
    BubbleView(
        parentBoundingBox: CGRect(x: 0, y: 0, width: 300, height: 300),
        difficulty: 1
    )
}
