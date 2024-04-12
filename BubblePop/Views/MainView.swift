//
//  ContentView.swift
//  BubblePop
//
//  Created by Tom Golding on 28/3/2024.
//

import SwiftUI
import UserNotifications

struct MainView: View {
//    @State private var selectedCountry: String = ""
    
    @EnvironmentObject var viewModel: MainViewModel

    var body: some View {
        VStack {
            if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
                accoundView
            } else {
                LoginView();
            }
        }
    }
    @ViewBuilder
    var accoundView: some View {
//        if viewModel.gameStarting {
//            MainMenuView()
//        } else {
            TabView {
                MainMenuView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }.toolbar(viewModel.gameStarting ? .hidden : .visible, for: .tabBar)
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                    }.toolbar(viewModel.gameStarting ? .hidden : .visible, for: .tabBar)
                LeaderBoardView()
                    .tabItem {
                        Label("Leader Board", systemImage: "medal.fill")
                    }.toolbar(viewModel.gameStarting ? .hidden : .visible, for: .tabBar)
            }.environmentObject(viewModel)
            
//            .environmentObject(viewModel)
        }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(MainViewModel())
    }
}


    //fileprivate struct Country {
    //    var id: String
    //    var name: String
    //}
    //
    //fileprivate func getLocales() -> [Country] {
    //    let locales = Locale.isoRegionCodes
    //        .filter { $0 != "Australia"}
    //        .compactMap { Country(id: $0, name: Locale.current.localizedString(forRegionCode: $0) ?? $0)}
    //    return [Country(id: "AUS", name: Locale.current.localizedString(forRegionCode: "AUS") ?? "Australia")] + locales
    //}
    //Text("Country:")
    //    .font(.system(size: 17))
    //if selectedCountry != "" {
    //    Text(Locale.current.localizedString(forRegionCode: selectedCountry) ?? selectedCountry)
    //        .font(.system(size: 17))
    //        .foregroundColor(Color("WhiteText"))
    // } else {
    //       Text("Select Country")
    //           .font(.system(size: 17))
    //           .foregroundColor(Color("GrayText"))
    //   }
    //
    // }
    //
    // Picker("Country", selection: $selectedCountry) {
    //     ForEach(getLocales(), id: \.id) { country in
    //     Text(country.name).tag(country.id)
    //     }
    // }.pickerStyle(.automatic)
