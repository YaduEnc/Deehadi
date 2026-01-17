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
            let fetchedCars: [Car] = try await SupabaseManager.shared.client
                .from("cars")
                .select()
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
