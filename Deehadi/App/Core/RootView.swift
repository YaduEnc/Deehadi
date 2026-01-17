import SwiftUI

struct RootView: View {
    @StateObject var session = UserSession.shared
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .transition(.opacity)
            } else {
                if session.isLoading {
                    // Minimal loading state if needed
                    ProgressView()
                } else if !session.isAuthenticated {
                    NavigationStack {
                        WelcomeView()
                    }
                    .transition(.opacity)
                } else if session.profile == nil || session.profile?.onboarding_completed == false {
                    // Authenticated but profile not loaded or onboarding incomplete
                    OnboardingFlowView()
                        .environmentObject(session)
                        .transition(.move(edge: .trailing))
                } else {
                    // Authenticated and profile set up
                    MainTabView()
                        .environmentObject(session)
                        .transition(.opacity)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}

#Preview {
    RootView()
}
