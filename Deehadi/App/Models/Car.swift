import Foundation

struct Car: Codable, Identifiable {
    let id: UUID
    let owner_id: UUID
    let registration_number: String
    let brand: String
    let model: String
    let year: Int
    let fuel_type: String
    let transmission: String
    let seats: Int
    let city: String
    let pickup_lat: Double?
    let pickup_lng: Double?
    let status: String
    let created_at: Date?
    
    var fullName: String {
        "\(brand) \(model) \(year)"
    }
    
    // Placeholder values for UI testing if not in DB yet
    var rating: Double { 5.0 }
    var tripsCount: Int { 12 }
    var pricePerDay: Int { 145 } // This will need to come from pricing_plans table later
    var hasInsurance: Bool { true }
    var isElectric: Bool { fuel_type.lowercased() == "electric" }
    
    var imageUrl: String {
        // Placeholder or first image from car_media
        "https://images.unsplash.com/photo-1555215695-3004980ad54e?q=80&w=2070&auto=format&fit=crop"
    }
}
