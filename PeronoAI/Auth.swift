import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct Auth: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isSigningUp = false  // Toggle sign-up vs. sign-in UI
    @State private var navigateToNextScreen = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text(isSigningUp ? "Sign Up" : "Sign In")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Email Input
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                
                // Password Input
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                
                // Display error if any
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                }
                
                // Sign Up / Sign In Button
                Button(isSigningUp ? "Sign Up" : "Sign In") {
                    if isSigningUp {
                        signUp()
                    } else {
                        signIn()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(isSigningUp ? Color.orange : Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal, 20)
                
                // Toggle between modes
                Button(isSigningUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up") {
                    isSigningUp.toggle()
                    errorMessage = nil
                }
                .foregroundColor(.blue)
            }
            .navigationDestination(isPresented: $navigateToNextScreen) {
                // Navigate to the appropriate view (Onboarding or Home)
                if hasCompletedOnboarding {
                    HomeView()
                } else {
                    Onboarding()
                }
            }
        }
    }
    
    // MARK: - Sign In Function (for Existing Users)
    private func signIn() {
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                DispatchQueue.main.async {
                    isLoggedIn = true
                    hasCompletedOnboarding = true  // Existing users skip onboarding
                    navigateToNextScreen = true
                }
            }
        }
    }
    
    // MARK: - Sign Up Function with Firestore "user" Collection Integration
    private func signUp() {
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else if let user = result?.user {
                // Prepare additional user data to store in Firestore
                let userData: [String: Any] = [
                    "uid": user.uid,
                    "email": user.email ?? "",
                    "createdAt": Timestamp(date: Date())
                    // Add additional fields here (e.g., "name": name, "preferences": ...)
                ]
                
                // Save the user data in Firestore under the "user" collection
                let db = Firestore.firestore()
                db.collection("user").document(user.uid).setData(userData) { err in
                    if let err = err {
                        print("Error writing user document: \(err.localizedDescription)")
                        // Optionally, you might want to handle errors here (e.g., show an alert)
                    } else {
                        print("User document successfully written!")
                    }
                    
                    DispatchQueue.main.async {
                        isLoggedIn = true
                        hasCompletedOnboarding = false  // New users should go through onboarding
                        navigateToNextScreen = true
                    }
                }
            }
        }
    }
}
