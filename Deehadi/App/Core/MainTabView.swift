import SwiftUI
import Auth
import Supabase
import PostgREST
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
                MyBookingsView()
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
    @State private var isApproving = false
    @State private var approvalSuccess = false
    
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
            
            Section("Developer Tools") {
                Button(action: {
                    Task {
                        guard let userId = SupabaseManager.shared.client.auth.currentUser?.id else { return }
                        isApproving = true
                        do {
                            try await SupabaseManager.shared.client
                                .from("kyc_records")
                                .update(["status": "approved"])
                                .eq("user_id", value: userId)
                                .execute()
                            approvalSuccess = true
                            isApproving = false
                        } catch {
                            print("Error approving KYC: \(error)")
                            isApproving = false
                        }
                    }
                }) {
                    HStack {
                        if isApproving {
                            ProgressView().padding(.trailing, 8)
                        }
                        Text(approvalSuccess ? "✅ KYC Approved!" : "Simulate KYC Approval")
                    }
                }
                .disabled(isApproving || approvalSuccess)
                .foregroundColor(approvalSuccess ? .green : .blue)
                
                if approvalSuccess {
                    Text("Now go to the Host tab to start listing!")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle("Profile")
    }
}
