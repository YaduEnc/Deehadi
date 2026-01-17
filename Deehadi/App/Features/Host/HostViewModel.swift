import Foundation
import SwiftUI
import Supabase
import Combine

enum KYCStatus: String {
    case notSubmitted = "not_submitted"
    case pending = "pending"
    case verified = "approved"
    case rejected = "rejected"
}

@MainActor
class HostViewModel: ObservableObject {
    @Published var kycStatus: KYCStatus = .notSubmitted
    @Published var myCars: [Car] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // KYC Form
    @Published var frontLicenseImage: UIImage?
    @Published var backLicenseImage: UIImage?
    @Published var isSubmittingKYC = false
    
    // Add Car Form
    @Published var brand: String = ""
    @Published var model: String = ""
    @Published var year: String = ""
    @Published var licensePlate: String = ""
    @Published var fuelType: String = "Petrol"
    @Published var transmission: String = "Automatic"
    @Published var seats: Int = 5
    @Published var city: String = ""
    @Published var pricePerDay: String = ""
    @Published var carImages: [UIImage] = []
    
    private let client = SupabaseManager.shared.client
    
    func checkKYCStatus() async {
        guard let userId = client.auth.currentUser?.id else { return }
        
        do {
            let response: [KYCRecord] = try await client
                .from("kyc_records")
                .select()
                .eq("user_id", value: userId)
                .execute()
                .value
            
            if let record = response.first {
                if let status = KYCStatus(rawValue: record.status) {
                    self.kycStatus = status
                } else {
                    self.kycStatus = .pending
                }
            } else {
                self.kycStatus = .notSubmitted
            }
        } catch {
            print("Error checking KYC: \(error)")
        }
    }
    
    func submitKYC() async {
        guard let userId = client.auth.currentUser?.id else { return }
        guard let front = frontLicenseImage, let back = backLicenseImage else {
            errorMessage = "Please upload both sides of your license."
            return
        }
        
        isSubmittingKYC = true
        errorMessage = nil
        
        do {
            // 1. Upload Images
            let frontUrl = try await uploadImage(image: front, bucket: "kyc-documents", path: "\(userId)/front.jpg")
            let backUrl = try await uploadImage(image: back, bucket: "kyc-documents", path: "\(userId)/back.jpg")
            
            // 2. Insert Record
            let record = KYCRecord(
                user_id: userId,
                document_type: "driving_license",
                front_image_url: frontUrl,
                back_image_url: backUrl,
                status: "pending"
            )
            
            try await client.from("kyc_records").insert(record).execute()
            
            self.kycStatus = .pending
            isSubmittingKYC = false
            
        } catch {
            errorMessage = "Failed to submit KYC: \(error.localizedDescription)"
            isSubmittingKYC = false
        }
    }
    
    func fetchMyCars() async {
        guard let userId = client.auth.currentUser?.id else { return }
        isLoading = true
        
        do {
            let cars: [Car] = try await client
                .from("cars")
                .select()
                .eq("owner_id", value: userId)
                .execute()
                .value
            
            self.myCars = cars
            isLoading = false
        } catch {
            print("Error fetching cars: \(error)")
            isLoading = false
        }
    }
    
    func addNewCar() async -> Bool {
        guard let userId = client.auth.currentUser?.id else { return false }
        isLoading = true
        errorMessage = nil
        
        do {
            // 1. Insert Car
            let newCar = CarInsert(
                owner_id: userId,
                registration_number: licensePlate,
                brand: brand,
                model: model,
                year: Int(year) ?? 2024,
                fuel_type: fuelType,
                transmission: transmission,
                seats: seats,
                city: city,
                status: "active"
            )
            
            let response: [Car] = try await client.from("cars").insert(newCar).select().execute().value
            guard let createdCar = response.first else { throw URLError(.badServerResponse) }
            
            // 2. Upload Images & Link
            for (index, image) in carImages.enumerated() {
                let path = "\(createdCar.id)/\(UUID().uuidString).jpg"
                let url = try await uploadImage(image: image, bucket: "car-images", path: path)
                
                let media = CarMediaInsert(car_id: createdCar.id, media_type: "image", url: url, position: index)
                try await client.from("car_media").insert(media).execute()
            }
            
            // 3. Set Price
            if let price = Double(pricePerDay) {
                let pricing = PricingPlanInsert(car_id: createdCar.id, price_per_day: price, currency: "USD")
                try await client.from("pricing_plans").insert(pricing).execute()
            }
            
            isLoading = false
            return true
            
        } catch {
            errorMessage = "Failed to add car: \(error.localizedDescription)"
            isLoading = false
            print(error)
            return false
        }
    }
    
    private func uploadImage(image: UIImage, bucket: String, path: String) async throws -> String {
        guard let data = image.jpegData(compressionQuality: 0.7) else { return "" }
        
        let fileOptions = FileOptions(cacheControl: "3600", upsert: true)
        
        _ = try await client.storage
            .from(bucket)
            .upload(path: path, file: data, options: fileOptions)
        
        return try client.storage.from(bucket).getPublicURL(path: path).absoluteString
    }
}

// MARK: - Encodable Models for Insert
struct KYCRecord: Encodable, Decodable {
    var user_id: UUID
    var document_type: String
    var front_image_url: String
    var back_image_url: String
    var status: String
}

struct CarInsert: Encodable {
    var owner_id: UUID
    var registration_number: String
    var brand: String
    var model: String
    var year: Int
    var fuel_type: String
    var transmission: String
    var seats: Int
    var city: String
    var status: String
}

struct CarMediaInsert: Encodable {
    var car_id: UUID
    var media_type: String
    var url: String
    var position: Int
}

struct PricingPlanInsert: Encodable {
    var car_id: UUID
    var price_per_day: Double
    var currency: String
}
