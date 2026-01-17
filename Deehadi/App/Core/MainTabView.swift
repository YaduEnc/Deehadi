import SwiftUI
import Auth
struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home
            HomeView()
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        Text("Home")
                    }
                }
                .tag(0)
            
            // Bookings
            NavigationStack {
                VStack {
                    Text("Your Bookings")
                        .font(AppTheme.Font.display(size: 24, weight: .bold))
                }
                .navigationTitle("Bookings")
            }
            .tabItem {
                VStack {
                    Image(systemName: "list.bullet.rectangle.fill")
                    Text("Bookings")
                }
            }
            .tag(1)
            
            // Host
            HostDashboardView()
            .tabItem {
                VStack {
                    Image(systemName: "key.fill")
                    Text("Host")
                }
            }
            .tag(2)
            
            // Profile
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                VStack {
                    Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                    Text("Profile")
                }
            }
            .tag(3)
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
