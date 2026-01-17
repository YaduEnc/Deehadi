import Foundation
import Supabase
import SwiftUI
import Combine

@MainActor
class BookingViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var bookingSuccess = false
    
    private let client = SupabaseManager.shared.client
    
    func createBooking(car: Car, startDate: Date, endDate: Date, dailyRate: Int) async -> Bool {
        guard let userId = client.auth.currentUser?.id else {
            errorMessage = "Please login to book a car."
            return false
        }
        
        isLoading = true
        errorMessage = nil
        
        // Calculate totals
        let days = max(1, Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 1)
        let totalRental = dailyRate * days
        let securityDeposit = 500 // Fixed for now
        let totalAmount = totalRental + securityDeposit
        
        do {
            // 1. Check KYC Status (Draft logic)
            let kycRecord: [KYCRecord] = try await client
                .from("kyc_records")
                .select()
                .eq("user_id", value: userId)
                .execute()
                .value
            
            guard let kyc = kycRecord.first, kyc.status == "approved" else {
                errorMessage = "Your KYC is not approved yet. Please verify your driving license."
                isLoading = false
                return false
            }
            
            // 2. Payment Simulation
            try await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 2 sec delay
            
            // 3. Insert Booking
            let insert = BookingInsert(
                car_id: car.id,
                renter_id: userId,
                start_time: startDate,
                end_time: endDate,
                status: "pending",
                total_amount: totalAmount,
                security_deposit: securityDeposit
            )
            
            try await client.from("bookings").insert(insert).execute()
            
            bookingSuccess = true
            isLoading = false
            return true
            
        } catch {
            errorMessage = "Booking failed: \(error.localizedDescription)"
            isLoading = false
            return false
        }
    }
}
