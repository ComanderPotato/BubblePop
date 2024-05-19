//
//  TLButton.swift
//  BubblePop
//
//  Created by Tom Golding on 5/4/2024.
//

import SwiftUI

// Simple button class for better extensibility 
struct BPButton: View {
    let title: String
    let background: Color
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(background)
                Text(title)
                    .foregroundColor(Color.white)
                    .bold()
            }
        }
        .padding()
    }
}

#Preview {
    BPButton(title: "Value",
             background: .pink) {
    }
}
