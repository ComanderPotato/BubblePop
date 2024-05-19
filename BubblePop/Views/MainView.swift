//
//  ContentView.swift
//  BubblePop
//
//  Created by Tom Golding on 28/3/2024.
//

import SwiftUI
import UserNotifications
struct MainView: View {
    @EnvironmentObject var viewModel: MainViewModel
    var body: some View {
        // If the user isn't signed in, it will show the loginview, else it will show the account view
        VStack {
            if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
                accoundView
            } else {
                LoginView();
            }
        }
    }
    @ViewBuilder
    // The account view is a tabview that shows tabs for 3 different views, the mainmenu the profile and leaderboard
    var accoundView: some View {
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
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(MainViewModel())
    }
}
