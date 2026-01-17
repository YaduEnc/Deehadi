import Foundation
import Supabase
import SwiftUI
import Combine

@MainActor
class MyBookingsViewModel: ObservableObject {
    @Published var bookings: [Booking] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let client = SupabaseManager.shared.client
    
    func fetchBookings() async {
        guard let userId = client.auth.currentUser?.id else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            // Fetch bookings with their associated cars and media
            let fetchedBookings: [Booking] = try await client
                .from("bookings")
                .select("*, car:cars(*, car_media(*), pricing_plans(*))")
                .eq("renter_id", value: userId)
                .order("start_time", ascending: false)
                .execute()
                .value
            
            self.bookings = fetchedBookings
            isLoading = false
        } catch {
            print("Error fetching bookings: \(error)")
            self.errorMessage = "Failed to load bookings."
            isLoading = false
        }
    }
    
    var upcomingBookings: [Booking] {
        bookings.filter { $0.status == "pending" || $0.status == "active" || $0.status == "disputed" }
    }
    
    var pastBookings: [Booking] {
        bookings.filter { $0.status == "completed" || $0.status == "cancelled" }
    }
}
