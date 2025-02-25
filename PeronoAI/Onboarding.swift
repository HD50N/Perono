import SwiftUI
struct Onboarding: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        TabView {
            OnboardingPageView(title: "Welcome!", description: "Discover great features.")
            OnboardingPageView(title: "Personalize", description: "Customize your experience.")
            OnboardingPageView(title: "Get Started", description: "Enjoy using the app!", isLast: true, onFinish: {
                hasCompletedOnboarding = true // ✅ Marks onboarding as permanently done
            })
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    }
}

struct OnboardingPageView: View {
    var title: String
    var description: String
    var isLast: Bool = false
    var onFinish: (() -> Void)? = nil

    var body: some View {
        VStack {
            Spacer()
            Text(title)
                .font(.title)
                .fontWeight(.bold)

            Text(description)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()

            if isLast {
                Button("Finish") {
                    onFinish?()
                }
                .buttonStyle(AuthButtonStyle(color: .green))
            }
        }
        .padding()
    }
}
