//
//  LoginViewViewModel.swift
//  BubblePop
//
//  Created by Tom Golding on 28/3/2024.
//

import FirebaseAuth
import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    init() {}
    
    // First validates that the inputs were correct, and logs the user in if the account exists
    func login() {
        guard validate() else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password)
    }
    // Used to validate the inputs, and change the error message if needed
    private func validate() -> Bool {
        errorMessage = ""
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all fields"
            return false
        }
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Email not formatted correctly"
            return false
        }
        return true
    }
}
