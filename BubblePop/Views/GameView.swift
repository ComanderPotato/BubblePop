//
//  GameView.swift
//  BubblePop
//
//  Created by Tom Golding on 25/3/2024.
//

import SwiftUI

struct GameView: View {
    // Combine GameViewModel and BubbleViewModel
    @StateObject var viewModel = GameViewModel()
    @StateObject var bubbleView = BubbleViewModel()
    @StateObject var gameTimer = TimerViewModel()
    @StateObject var countDownTimer = TimerViewModel(totalTime: 3)
    @EnvironmentObject var mainViewModel: MainViewModel

    private var numberOfBubbles: Int
    private var totalTime: TimeInterval
    private var difficulty: Int
    
    init(numberOfBubbles: Double, totalTime: Double, difficulty: Int) {
        self.numberOfBubbles = Int(numberOfBubbles)
        self.totalTime = TimeInterval(totalTime)
        self.difficulty = difficulty
    }
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    var body: some View {
        VStack {
            if !(countDownTimer.totalTime > 0) {
                GameHeaderView(
                    gameTime: gameTimer.totalTime,
                    gameScore: viewModel.gameScore,
                    highScore: viewModel.gameScore,
                    difficulty: self.difficulty,
                    isActive: gameTimer.isActive,
                    stopAnimation: bubbleView.stopAnimating,
                    startAnimation: bubbleView.startAnimating,
                    setIsActive: gameTimer.setIsActive)
            }
            Spacer()
            GeometryReader { geometry in
                if countDownTimer.totalTime > 0 {
                    HStack {
                        Text("\(countDownTimer.totalTime.formatted())")
                            .bold()
                            .font(.system(size: 200))
                    }.frame(width: geometry.size.width, height: geometry.size.height)
                } else {
                    if !gameTimer.isActive {
                        HStack {
                            ZStack {
                                Text("Paused")
                                    
                            }.background(.gray)
                                .padding()
                                .frame(width: 200, height: 200)
                                .opacity(1)
                        }.frame(width: geometry.size.width, height: geometry.size.height)
                            .opacity(0.5)
                            .zIndex(10)
                    }
                ZStack {
                    ForEach(Array(bubbleView.bubbles.keys), id: \.self) { key in
                        bubbleView.bubbles[key]
                    }
                }.overlay(
                    
                    ForEach(Array(bubbleView.bubbles.keys), id: \.self) { key in
                        let current = bubbleView.bubbles[key]
                        current.onTapGesture {
                            if gameTimer.isActive {
                                if viewModel.previousBubble != nil {
                                    viewModel.multiplier = (viewModel.previousBubble?.color == current?.color) ? 1.5 : 1
                                }
                                viewModel.previousBubble = current
                                viewModel.gameScore += (current!.points * viewModel.multiplier)
                                
                                bubbleView.removeBubble(id: key)
                            }
                        }
                    }
                ).onAppear(perform: {
                    gameTimer.setTime(newTime: totalTime)
                    bubbleView.setParameters(parentBoundingBox: geometry.frame(in: .global), difficulty: self.difficulty)
                    bubbleView.generateBubbles(
                        numberOfBubbles: self.numberOfBubbles)
                    gameTimer.startTimer()
                    if self.difficulty > 0 {
                        bubbleView.startAnimating()
                    }
                })
            }
        }.onReceive(timer) { time in
            guard isActive else {
                return
            }
            countDownTimer.totalTime > 0 ? countDownTimer.runTimer() : countDownTimer.destroyTimer()
            if gameTimer.totalTime > 0 {
                gameTimer.runTimer()
            }
            if gameTimer.totalTime == 0 {
                viewModel.insertNewScore()
                mainViewModel.setGameStarting()
            }
            if gameTimer.totalTime.truncatingRemainder(dividingBy: 1) == 0 && gameTimer.totalTime < 60 && 
                gameTimer.isActive{
                bubbleView.generateBubbles(numberOfBubbles: self.numberOfBubbles)
            }
        }.onAppear() {
            countDownTimer.startTimer()
        }
        }
    }
}

#Preview {
    GameView(
        numberOfBubbles: 15,
        totalTime: 40,
        difficulty: 0
    ).environmentObject(MainViewModel())
}
