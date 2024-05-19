//
//  LeaderBoardViewViewModel.swift
//  BubblePop
//
//  Created by Tom Golding on 28/3/2024.
//

import Foundation
import FirebaseFirestore
class LeaderBoardViewModel: ObservableObject {
    @Published var leaderBoard: [Score]? = nil
    init() {
        fetchLeaderBoard()
    }
    
    // Retrieves all the scores from the Firestore database, then sorts them in ascending order and shortens the array
    func fetchLeaderBoard() {
        let db = Firestore.firestore()
        db.collection("scores").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Fetch error: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("Snapshot is nil")
                return
            }
            
            DispatchQueue.main.async {
                self.leaderBoard = snapshot.documents.compactMap { document -> Score? in
                    let data = document.data()
                    return Score(
                        id: data["id"] as? String ?? "",
                        userId: data["userId"] as? String ?? "",
                        name: data["name"] as? String ?? "",
                        score: data["score"] as? Double ?? 0.0
                    )
                }
                self.leaderBoard?.sort { $0.score > $1.score }
                self.shortenLeaderBoard()
            }
        }
    }
    // Makes sure the leaderboard is only 100 long
    private func shortenLeaderBoard() -> Void {
        guard var leaderBoard = self.leaderBoard else {
            return
        }
        let db = Firestore.firestore()
        while leaderBoard.count > 100 {
            print("Hello")
            let last = leaderBoard.popLast()
            db.collection("users")
                .document(last!.id)
                .delete()
        }
    }
}
