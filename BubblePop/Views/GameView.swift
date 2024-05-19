//
//  GameView.swift
//  BubblePop
//
//  Created by Tom Golding on 25/3/2024.
//

import SwiftUI


// The main view for the game
struct GameView: View {
    @StateObject var viewModel: GameViewModel
    // Basic timer
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    // Used to pause the game if the user closes the app
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var mainViewModel: MainViewModel
    @State private var isActive = true
    @State var isPaused = false
    var body: some View {
        VStack {
            // If the countdown is not 0, show the "countdown screen" which just displays the countdown number
            if viewModel.getCountDownTime() > 0 {
                HStack {
                    Text("\(viewModel.getCountDownTime().formatted())")
                        .bold()
                        .font(.system(size: 200))
                }
            } else {
                // Game Header with the necessary data
                GameHeaderView(
                    gameTime: viewModel.getGameTime(),
                    gameScore: viewModel.gameScore,
                    highScore: viewModel.gameScore,
                    difficulty: viewModel.difficulty,
                    isActive: viewModel.isGameTimerActive(),
                    stopAnimation: viewModel.stopAnimating,
                    startAnimation: viewModel.startAnimating,
                    toggleIsActive: viewModel.toggleIsActive)
                Spacer()
                
                GeometryReader { geometry in
                    // Loop through the bubbles array
                    ForEach(Array(viewModel.bubbles.enumerated()), id: \.element.id) { index, bubble in
                        // Displays the bubble and adds the tap functionality that updates the scores and removes the selected bubble
                        bubble.onTapGesture {
                            if viewModel.isGameTimerActive() {
                                if viewModel.previousBubbleColor != BubbleColors.nothing {
                                    viewModel.setMultiplier(currentBubbleColor: bubble.self.viewModel.bubbleColor)
                                }
                                viewModel.setPreviousBubbleColor(currentBubbleColor: bubble.self.viewModel.bubbleColor)
                                viewModel.updateGameScore(bubblePoints: bubble.self.viewModel.points)
                                viewModel.removeBubble(indexToRemove: index)

                            }
                        }
                }
                    VStack {
                    }
                    .onAppear(perform: {
                        // On appear, we set the bounding box of the viewmodel
                        viewModel.setParentBoundingBox(parentBoundingBox: geometry.frame(in: .global))
                        viewModel.setBubbleViewModel(parentBoundingBox: geometry.frame(in: .global))
                        // Also generate some bubbles
                        viewModel.generateBubbles()
                        // If the difficulty is greater than 0, animate the bubbles
                        if viewModel.difficulty > 0 {
                            viewModel.startAnimating()
                        }
                        // Start the game timer
                        viewModel.gameTimer.startTimer()
                    })
                }
            }
        }.onReceive(timer) {time in
            // If the game isn't active nothing happens
            guard isActive else {
                return
            }
            // Switch statement to decrement the countdown or game timer based on if countDown is 0 or not
            viewModel.countDownTime > 0 ? viewModel.decrementCountDownTime() : viewModel.decrementGameTime()
            if viewModel.gameTime == 0 {
               viewModel.insertNewScore()
               mainViewModel.setGameStarting()
           }
            // Every second, random bubbles are removed and generated
            if viewModel.gameTime.truncatingRemainder(dividingBy: 1) == 0 && viewModel.gameTime < 60 &&
                viewModel.isGameTimerActive() {
                viewModel.removeRandomBubbles()
                viewModel.generateBubbles()
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    GameView(viewModel: .init(gameTime: 20, numberOfBubbles: 15, difficulty: 0))
        .environmentObject(MainViewModel())
}

