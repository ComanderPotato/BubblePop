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
    
    
//    func fetchLeaderBoard() -> Void {
//        let db = Firestore.firestore()
//        db.collection("scores").getDocuments { (snapeshot, error) in
//            if let error = error {
//                print("Fetch error")
//            } else {
//                for document in snapeshot!.documents {
//                    let data = document.data()
//                    self.leaderBoard.append(Score (
//                        id: data["id"] as? String ?? "",
//                        userId: data["userId"] as? String ?? "",
//                        name: data["name"] as? String ?? "",
//                        score: data["score"] as? Double ?? 0.0
//                    ))
//                }
//                self.leaderBoard.sort { (a, b) in
//                    a.score < b.score
//                }
//                self.shortenLeaderBoard()
//            }
//        }
//    }
    
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
    private func shortenLeaderBoard() -> Void {
        guard var leaderBoard = self.leaderBoard else {
            return
        }
        while leaderBoard.count > 100 {
            let last = leaderBoard.popLast()
            let db = Firestore.firestore()
            db.collection("users")
                .document(last!.id)
                .delete()
        }
    }
}
