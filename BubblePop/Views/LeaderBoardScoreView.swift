//
//  LeaderBoardScoreView.swift
//  BubblePop
//
//  Created by Tom Golding on 28/3/2024.
//

import SwiftUI
// View for an individual score on the leaderboard, chooses a colour if it is in the top 3
struct LeaderBoardScoreView: View {
    let index: Int
    let score: Score
    let color: Color
    let gold: Color = Color(red: 219/255, green: 172/255, blue: 52/255)
    let silver: Color = Color(red: 192/255, green: 192/255, blue: 192/255)
    let bronze: Color = Color(red: 205/255, green: 127/255, blue: 50/255)
    func getTopColours() -> Color {
        if(index == 0) {
            return gold
        } else if(index == 1) {
            return silver
        } else if index == 2 {
            return bronze
        } else {
            return .white
        }
    }
    var body: some View {
        VStack {
            HStack {
                Text("\(index + 1)")
                Text("\(score.name)")
                Spacer()
                Text("\(score.score.formatted())")
            }.padding()
        }.background(getTopColours())
           
    }
}

#Preview {
    LeaderBoardScoreView(index: 0, score: .init(
            id: "123",
            userId: "123",
            name: "Bob Golding",
            score: 123.5
    ),      color: Color(red: 219/255, green: 172/255, blue: 52/255)
                            
    )
}
