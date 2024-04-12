//
//  RegisterView.swift
//  BubblePop
//
//  Created by Tom Golding on 28/3/2024.
//


import SwiftUI
fileprivate struct Country {
    var id: String
    var name: String
}
fileprivate func getLocales() -> [Country] {
    let locales = Locale.isoRegionCodes
        .filter { $0 != "Australia"}
        .compactMap { Country(id: $0, name: Locale.current.localizedString(forRegionCode: $0) ?? $0)}
    return [Country(id: "AU", name: Locale.current.localizedString(forRegionCode: "AU") ?? "Australia")] + locales
}
struct RegisterView: View {
    @StateObject var viewModel = RegisterViewModel()
    
    var body: some View {
        VStack {
            Form {
                TextField("Full name", text: $viewModel.name)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocorrectionDisabled()
                TextField("Email Address", text: $viewModel.email)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .autocorrectionDisabled()

            Picker("Country \(flag(country: viewModel.origin))", selection: $viewModel.origin) {
                     ForEach(getLocales(), id: \.id) { country in
                     Text(country.name).tag(country.id)
                     }
                 }.pickerStyle(.automatic)
                TLButton(title: "Create Account",
                         background: .green) {
                        // Attemp registration
                    viewModel.register()
                }
            }
//            .offset(y: -50)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
