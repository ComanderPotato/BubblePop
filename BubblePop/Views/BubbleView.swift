//
//  BubbleView.swift
//  BubblePop
//
//  Created by Tom Golding on 25/3/2024.
//

import SwiftUI
// BubbleView is how the bubbles will be displayed
struct BubbleView: View, Identifiable {
    // Instantiated viewModel for BubbleViewModel, which is assigned when view is made with the geometry of the game view and difficulty
    @ObservedObject var viewModel: BubbleViewModel
    let id = UUID().uuidString
    @State var scale: Double = 0.0
    @State var opacity: Double = 1.0
    var body: some View {
        // Just a circle with important key features like the color, the radius which changes based on difficulty, and the coordinates which are randomly assigned on creation
        Circle()
            .shadow(color: getColor(), radius: 5)
            .foregroundStyle(getColor())
            .frame(width: viewModel.radius * 2, height: viewModel.radius * 2)
            .position(x: viewModel.xCoord, y: viewModel.yCoord)
            .scaleEffect(self.scale,
                         anchor: UnitPoint(
                            x: viewModel.xCoord / (viewModel.halfWidth * 2),
                            y: viewModel.yCoord  / (viewModel.halfHeight * 2)
                         )
            )
            .opacity(self.opacity)
            .onAppear {
                let baseAnimation = Animation.easeInOut(duration: 0.5)
                    withAnimation(baseAnimation) {
                        self.scale = 1
                    }
            }
    }
    // Function to get the color of the bubble
    func getColor() -> Color {
        // Switch statement for the bubbleColor, which is an enum containing all available colors
        switch(viewModel.bubbleColor) {
            case .black:
                return Color.black
            case .red:
                return Color.red
            case .pink:
                return Color.pink
            case .blue:
                return Color.blue
            case .green:
                return Color.green
            default:
                return Color.white
        }
    }
}
#Preview {
    BubbleView(viewModel: .init(
        parentBoundingBox: CGRect(x: 0, y: 0, width: 300, height: 300),
        difficulty: 0)
    )
}
