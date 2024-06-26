//
//  ProfileViewModel.swift
//  BubblePop
//
//  Created by Tom Golding on 4/4/2024.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class ProfileViewModel: ObservableObject {
    @Published var user: User? = nil
    init() {}
    // Method to fetch the current user from the database
    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            DispatchQueue.main.async {
                self?.user = User(
                    id: data["id"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    highScore: data["highScore"] as? Double ?? 0.0,
                    joined: data["joined"] as? TimeInterval ?? 0)
            }
        }
    }
    // Logs the user out of the application
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}

