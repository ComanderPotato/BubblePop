//
//  LeaderBoardView.swift
//  BubblePop
//
//  Created by Tom Golding on 28/3/2024.
//

import SwiftUI

struct LeaderBoardView: View {
    @StateObject var viewModel = LeaderBoardViewModel()
    var body: some View {
        VStack {
            if let leaderBoard = viewModel.leaderBoard {
                HStack {
                    Text("Name")
                    Spacer()
                    Text("High score")
                }
                .padding(20)
                List(leaderBoard.indices, id: \.self) { index in
                    let score = leaderBoard[index]
                    LeaderBoardScoreView(index: index, score: score, color: .red)
                }
//                .listStyle(PlainListStyle())
                .listStyle(PlainListStyle())
                
            } else {
                Text("Loading profile...")
            }
        }.onAppear(perform: {
            viewModel.fetchLeaderBoard()
        })
    }
}

#Preview {
    LeaderBoardView()
}

