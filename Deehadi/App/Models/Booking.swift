import Foundation

struct Booking: Codable, Identifiable {
    let id: UUID
    let car_id: UUID
    let renter_id: UUID
    let start_time: Date
    let end_time: Date
    let status: String
    let total_amount: Int
    let security_deposit: Int
    let late_fee: Int?
    let created_at: Date?
    
    // Optional relations
    var car: Car?
    var renter: UserProfile?
}

struct BookingInsert: Encodable {
    let car_id: UUID
    let renter_id: UUID
    let start_time: Date
    let end_time: Date
    let status: String
    let total_amount: Int
    let security_deposit: Int
}
