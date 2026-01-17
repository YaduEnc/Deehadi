import Foundation

struct PricingPlan: Codable {
    let price_per_day: Double
    let currency: String
}

struct CarMedia: Codable {
    let url: String
    let media_type: String
    let position: Int
}

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
    let features: [String]?
    let created_at: Date?
    
    // Relations from Supabase
    let pricing_plans: [PricingPlan]?
    let car_media: [CarMedia]?
    
    var fullName: String {
        "\(brand) \(model) \(year)"
    }
    
    var rating: Double { 0.0 }
    var tripsCount: Int { 0 }
    
    var pricePerDay: Int {
        if let price = pricing_plans?.first?.price_per_day {
            return Int(price)
        }
        return 0
    }
    
    var hasInsurance: Bool { true }
    var isElectric: Bool { fuel_type.lowercased() == "electric" }
    
    var imageUrl: String {
        // Use first image from car_media
        if let firstImageUrl = car_media?.sorted(by: { $0.position < $1.position }).first?.url {
            return firstImageUrl
        }
        return "" // No real photo available
    }
}
