import Foundation
import Combine
import Supabase

class AuthService: ObservableObject {
    @Published var isLoading = false
    @Published var error: String?
    
    private let client = SupabaseManager.shared.client
    
    func signUp(email: String, password: String) async -> Bool {
        await MainActor.run {
            self.isLoading = true
            self.error = nil
        }
        
        do {
            try await client.auth.signUp(email: email, password: password)
            await UserSession.shared.checkSession()
            await MainActor.run { self.isLoading = false }
            return true
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.error = error.localizedDescription
            }
            return false
        }
    }
    
    func signIn(email: String, password: String) async -> Bool {
        await MainActor.run {
            self.isLoading = true
            self.error = nil
        }
        
        do {
            try await client.auth.signIn(email: email, password: password)
            await UserSession.shared.checkSession()
            await MainActor.run { self.isLoading = false }
            return true
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.error = error.localizedDescription
            }
            return false
        }
    }
}
