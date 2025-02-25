import SwiftUI

struct WelcomeView: View {
    @State private var navigateToAuth = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to PeronoAI!")
                    .font(.largeTitle)
                    .padding()

                Button("Get Started") {
                    navigateToAuth = true
                }
                .buttonStyle(AuthButtonStyle(color: .blue))
                .navigationDestination(isPresented: $navigateToAuth) {
                    Auth()
                }
            }
        }
    }
}

