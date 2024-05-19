//
//  MainMenuView.swift
//  BubblePop
//
//  Created by Tom Golding on 4/4/2024.
//

import SwiftUI
// The main menu of the application, it will allow a user to set certain settings of the game and press play to pop some bubbles
struct MainMenuView: View {
    @State private var numberOfBubbles: Double = 15.0
    @State private var gameTime: Double = 60.0
    @State private var isEditing = false
    @State private var difficulty = 0
    @State private var gameStarting: Bool = false
    @EnvironmentObject var viewModel: MainViewModel
    var body: some View {
        if viewModel.gameStarting {
            GameView(viewModel: .init(
                gameTime: gameTime,
                numberOfBubbles: Int(numberOfBubbles),
                difficulty: difficulty)
            ).environmentObject(viewModel)
        } else {
            VStack {
                Text("Bubble Pop!")
                Text("Number of bubbles")
                    Slider(
                        value: $numberOfBubbles,
                        in: 0...15,
                        step: 1
                    )
                
                Text("\(numberOfBubbles.formatted())")
                
                Text("Time")
                    Slider(
                        value: $gameTime,
                        in: 0...60,
                        step: 1
                    )
                
                Text("\(gameTime.formatted())")
                Text("Difficulty")
                Picker("Difficulty", selection: $difficulty) {
                    Text("Easy").tag(0)
                    Text("Medium").tag(1)
                    Text("Hard").tag(2)
                    Text("Impossible").tag(3)
                    }.pickerStyle(.automatic)

                Button("Start Game") {
                    viewModel.setGameStarting()
                }
            }.frame(maxWidth: 500)
        }
    }

}

#Preview {
    MainMenuView().environmentObject(MainViewModel())
}


