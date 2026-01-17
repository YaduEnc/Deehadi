import Foundation
import Combine
import Supabase

@MainActor
class HomeViewModel: ObservableObject {
    @Published var cars: [Car] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var selectedCategory: String = "All"
    
    let categories = ["All", "Sedan", "SUV", "Electric", "Luxury"]
    
    func fetchCars() async {
        isLoading = true
        error = nil
        
        do {
            var query = SupabaseManager.shared.client
                .from("cars")
                .select("*, car_media(*), pricing_plans(*)")
                .eq("status", value: "active")
            
            // Apply category filter if needed (simple implementation based on fuel_type for now)
            if selectedCategory == "Electric" {
                query = query.ilike("fuel_type", value: "electric")
            }
            
            let fetchedCars: [Car] = try await query
                .order("created_at", ascending: false)
                .execute()
                .value
            
            self.cars = fetchedCars
            self.isLoading = false
        } catch {
            self.error = error.localizedDescription
            self.isLoading = false
            print("Error fetching cars: \(error)")
        }
    }
}
