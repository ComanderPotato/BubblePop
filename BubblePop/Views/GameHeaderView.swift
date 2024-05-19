//
//  GameHeaderView.swift
//  BubblePop
//
//  Created by Tom Golding on 9/4/2024.
//

import SwiftUI
// GameHeader for better extensibility, takes a certain number of data such as game timer and score, and methods to pause and un-pause the game
struct GameHeaderView: View {
    let gameTime: TimeInterval
    let gameScore: Double
    let highScore: Double
    let difficulty: Int
    var isActive: Bool
    let stopAnimation: () -> Void
    let startAnimation: () -> Void
    let toggleIsActive: () -> Void
    var body: some View {
        ZStack {
            HStack {
                VStack {
                    Text("Timer")
                    Text("\(self.gameTime.formatted())")
                }
                Spacer()
                VStack {
                    Text("Score")
                    Text("\(self.gameScore.formatted())")
                }
                Spacer()
                VStack {
                    Text("High score")
                    Text("\(self.highScore.formatted())")
                }
                Spacer()
                VStack {
                    if self.isActive {
                        Image(systemName: "play.fill").resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    } else {
                        Image(systemName: "pause.fill").resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    }
                }.onTapGesture {
                    if self.difficulty > 0 {
                        if self.isActive {
                            self.stopAnimation()
                        } else {
                            self.startAnimation()
                        }
                    }
                    self.toggleIsActive()
                }
            }
        }
        .padding()
    }
}

#Preview {
    GameHeaderView(
        gameTime: 0,
        gameScore: 0,
        highScore: 0,
        difficulty: 0,
        isActive: true,
        stopAnimation: {},
        startAnimation: {},
        toggleIsActive: {}
    )
}
