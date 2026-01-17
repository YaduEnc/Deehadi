import Foundation
import Combine
import Supabase

class UserSession: ObservableObject {
    static let shared = UserSession()
    
    @Published var session: Session?
    @Published var profile: UserProfile?
    @Published var isLoading = true
    
    var isAuthenticated: Bool {
        session != nil
    }
    
    private init() {
        Task {
            await checkSession()
        }
    }
    
    func checkSession() async {
        do {
            let session = try await SupabaseManager.shared.client.auth.session
            await MainActor.run {
                self.session = session
            }
            
            if session != nil {
                await fetchProfile()
            } else {
                await MainActor.run {
                    self.isLoading = false
                }
            }
        } catch {
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    func fetchProfile() async {
        guard let userId = session?.user.id else { 
            await MainActor.run { self.isLoading = false }
            return 
        }
        
        do {
            let profile: UserProfile = try await SupabaseManager.shared.client
                .from("user_profiles")
                .select()
                .eq("id", value: userId)
                .single()
                .execute()
                .value
            
            await MainActor.run {
                self.profile = profile
                self.isLoading = false
            }
        } catch {
            print("Profile fetch failed: \(error.localizedDescription)")
            // If profile is missing (406 or Not Found), the user record was likely deleted
            // We should treat this as unauthenticated so they can sign up again
            await signOut()
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    func signOut() async {
        do {
            try await SupabaseManager.shared.client.auth.signOut()
            await MainActor.run {
                self.session = nil
                self.profile = nil
            }
        } catch {
            print("Error signing out: \(error)")
        }
    }
}

// Comprehensive model for profile fetching
struct UserProfile: Codable {
    let id: UUID
    var full_name: String?
    var dob: String?
    var profile_photo_url: String?
    var phone_number: String?
    var is_owner: Bool?
    var address: String?
    var city: String?
    var state: String?
    var pincode: String?
    var onboarding_completed: Bool?
}
