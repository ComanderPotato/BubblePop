//
//  LoadingAnimationView.swift
//  BubblePop
//
//  Created by Tom Golding on 13/4/2024.
//

import SwiftUI
// Little loading animation of a spinning shape
struct LoadingAnimationView: View {
    @StateObject var viewModel = LoadingAnimationViewModel()
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: viewModel.cornerRadius)
                .foregroundStyle(.blue)
                .frame(width: viewModel.width, height: viewModel.height)
                .rotationEffect(.degrees(viewModel.rotation))
                .onAppear(perform: {
                    viewModel.startAnimating()
                })
        }
    }
}

#Preview {
    LoadingAnimationView()
}
