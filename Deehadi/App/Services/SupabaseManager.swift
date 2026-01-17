import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        self.client = SupabaseClient(
            supabaseURL: Constants.Supabase.url,
            supabaseKey: Constants.Supabase.apiKey
        )
    }
}
