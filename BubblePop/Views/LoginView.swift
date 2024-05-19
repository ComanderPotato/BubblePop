//
//  LoginView.swift
//  BubblePop
//
//  Created by Tom Golding on 28/3/2024.
//

import SwiftUI
// Login view to allow the user to log into the application 
struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Form {
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundStyle(.red)
                    }
                    TextField("Email address", text: $viewModel.email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .autocorrectionDisabled()
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .autocorrectionDisabled()
                    BPButton(
                        title: "Log in",
                        background: .blue
                    ) {
                        viewModel.login()
                    }
                }
                Spacer()
                VStack {
                    Text("Don't have an account?")
                    NavigationLink("Create An Account",
                                   destination: RegisterView())
                }
                .padding(.bottom, 50)
                Spacer()
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                
        }
        .frame(maxWidth: 400)
    }
}
#Preview {
    LoginView()
}
