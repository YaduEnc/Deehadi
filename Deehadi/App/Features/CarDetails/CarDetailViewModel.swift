import Foundation
import Supabase
import Combine

@MainActor
class CarDetailViewModel: ObservableObject {
    @Published var ownerProfile: UserProfile?
    @Published var isLoading = false
    
    func fetchOwnerProfile(ownerId: UUID) async {
        isLoading = true
        do {
            let profile: UserProfile = try await SupabaseManager.shared.client
                .from("user_profiles")
                .select()
                .eq("id", value: ownerId)
                .single()
                .execute()
                .value
            
            self.ownerProfile = profile
            self.isLoading = false
        } catch {
            print("Error fetching owner profile: \(error)")
            self.isLoading = false
        }
    }
}
