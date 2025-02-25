//
//  AuthButtonStyle.swift
//  PeronoAI
//
//  Created by Hudson Chung on 2/9/25.
//

import SwiftUI

struct AuthButtonStyle: ButtonStyle {
    var color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}
