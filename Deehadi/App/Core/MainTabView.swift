import SwiftUI
import Auth
struct MainTabView: View {
    var body: some View {
        TabView {
            // Home
            NavigationStack {
                VStack {
                    Text("Home / Search")
                        .font(AppTheme.Font.display(size: 24, weight: .bold))
                }
                .navigationTitle("Explore")
            }
            .tabItem {
                Label("Explore", systemImage: "magnifyingglass")
            }
            
            // Bookings
            NavigationStack {
                VStack {
                    Text("Your Bookings")
                        .font(AppTheme.Font.display(size: 24, weight: .bold))
                }
                .navigationTitle("Trips")
            }
            .tabItem {
                Label("Trips", systemImage: "car.fill")
            }
            
            // Profile
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
        }
        .tint(AppTheme.Color.primary)
    }
}

struct ProfileView: View {
    @EnvironmentObject var session: UserSession
    
    var body: some View {
        List {
            Section("Account") {
                Text(session.profile?.full_name ?? "User")
                Text(session.session?.user.email ?? "")
            }
            
            Section {
                Button("Sign Out", role: .destructive) {
                    Task {
                        await session.signOut()
                    }
                }
            }
        }
        .navigationTitle("Profile")
    }
}
