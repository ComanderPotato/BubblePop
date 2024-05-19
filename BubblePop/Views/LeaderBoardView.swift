//
//  LeaderBoardView.swift
//  BubblePop
//
//  Created by Tom Golding on 28/3/2024.
//

import SwiftUI
// the Leaderboard view which allows you to see the total leaderboard, on load it will fetch all scores from the database and dynamically display them with a ForEach loop
struct LeaderBoardView: View {
    @StateObject var viewModel = LeaderBoardViewModel()
    var body: some View {
        VStack {
            if let leaderBoard = viewModel.leaderBoard {
                HStack {
                    Text("#")
                    Text("Name")
                    Spacer()
                    Text("High score")
                }
                .padding(20)
                ScrollView {
                    ForEach(Array(leaderBoard.enumerated()), id: \.element.id) { index, score in
                        let score = leaderBoard[index]
                        LeaderBoardScoreView(index: index, score: score, color: .red)
                    }
                }
            } else {
                LoadingAnimationView()
            }
        }.onAppear(perform: {
            viewModel.fetchLeaderBoard()
        })
    }
}

#Preview {
    LeaderBoardView()
}

