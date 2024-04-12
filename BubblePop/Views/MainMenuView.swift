//
//  MainMenuView.swift
//  BubblePop
//
//  Created by Tom Golding on 4/4/2024.
//

import SwiftUI

struct MainMenuView: View {
    @State private var numberOfBubbles: Double = 15.0
    @State private var totalTime: Double = 60.0
    @State private var isEditing = false
    @State private var difficulty = 0
    @State private var gameStarting: Bool = false
    @EnvironmentObject var viewModel: MainViewModel
    var body: some View {
        if viewModel.gameStarting {
            GameView(
                numberOfBubbles: numberOfBubbles,
                totalTime: totalTime,
                difficulty: difficulty
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
                        value: $totalTime,
                        in: 0...60,
                        step: 1
                    )
                
                Text("\(totalTime.formatted())")
                Text("Difficulty")
                Picker("Difficulty", selection: $difficulty) {
                    Text("Easy").tag(0)
                    Text("Medium").tag(1)
                    Text("Hard").tag(2)
                    Text("Impossible").tag(3)
                    }.pickerStyle(.automatic)
//                    
//                NavigationLink("Start Game", 
//                               destination: GameView(
//                                numberOfBubbles: numberOfBubbles,
//                                totalTime: totalTime,
//                                difficulty: difficulty
//                            ))
                Button("Start Game") {
                    viewModel.setGameStarting()
                }
//                Text("\(viewModel.test)")
            }
//            .navigationBarBackButtonHidden()
        }
    }

}

#Preview {
    MainMenuView().environmentObject(MainViewModel())
}


