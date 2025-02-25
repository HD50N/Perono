import SwiftUI

// MARK: - Tab Enum

enum Tab: String, CaseIterable, Identifiable {
    case home = "house.fill"
    case lessons = "book.fill"
    case profile = "person.fill"
    
    var id: String { self.rawValue }
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .lessons:
            return "Lessons"
        case .profile:
            return "Profile"
        }
    }
}

// MARK: - Minimal Content Views

struct MinimalDashboardView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Gradient background for Home
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Welcome to PeronoAI")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    Text("Your personalized dashboard shows your progress and recommendations.")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MinimalLessonsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Gradient background for Lessons
                LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Lessons")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    Text("Access your structured lessons and track your learning progress.")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Lessons")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MinimalProfileView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = true
    
    var body: some View {
        NavigationView {
            ZStack {
                // Gradient background for Profile
                LinearGradient(gradient: Gradient(colors: [Color.green, Color.teal]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Profile")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    Text("Manage your account and update your preferences.")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    
                    Button(action: {
                        isLoggedIn = false
                    }) {
                        Text("Log Out")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4)
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Custom Bottom Navigation Bar

struct CustomBottomNavBar: View {
    @Binding var selectedTab: Tab
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(Tab.allCases) { tab in
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.rawValue)
                            .font(.system(size: 20, weight: .bold))
                        Text(tab.title)
                            .font(.caption)
                    }
                    .padding()
                    .foregroundColor(selectedTab == tab ? .white : .gray)
                    .background(
                        ZStack {
                            if selectedTab == tab {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue)
                                    .matchedGeometryEffect(id: "background", in: animation)
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.clear)
                            }
                        }
                    )
                    .shadow(color: selectedTab == tab ? Color.blue.opacity(0.5) : Color.black.opacity(0.1),
                            radius: 5, x: 0, y: 4)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        // Remove any unwanted background by not applying a default bar background here
    }
}

// MARK: - Custom Tab View Container

struct CustomTabView: View {
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                // Display the selected content with a smooth fade transition
                switch selectedTab {
                case .home:
                    MinimalDashboardView().transition(.opacity)
                case .lessons:
                    MinimalLessonsView().transition(.opacity)
                case .profile:
                    MinimalProfileView().transition(.opacity)
                }
            }
            .animation(.easeInOut, value: selectedTab)
            
            // Custom Bottom Navigation Bar without an extra white background
            CustomBottomNavBar(selectedTab: $selectedTab)
                .padding(.bottom, 8)
        }
        // Extend the background to the bottom edge
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

// MARK: - HomeView (Main Container)

struct HomeView: View {
    var body: some View {
        CustomTabView()
    }
}

// MARK: - Preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
