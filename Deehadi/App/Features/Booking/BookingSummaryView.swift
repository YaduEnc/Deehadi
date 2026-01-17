import SwiftUI

struct BookingSummaryView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = BookingViewModel()
    
    let car: Car
    let startDate: Date
    let endDate: Date
    
    var numberOfDays: Int {
        max(1, Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 1)
    }
    
    var totalRental: Int {
        car.pricePerDay * numberOfDays
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AppTheme.Color.backgroundLight.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    
                    // Header
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .frame(width: 44, height: 44)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.05), radius: 10)
                        }
                        
                        Text("Booking Summary")
                            .font(AppTheme.Font.display(size: 20, weight: .bold))
                            .padding(.leading, 12)
                        
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    // Car Compact Card
                    HStack(spacing: 16) {
                        AsyncImage(url: URL(string: car.imageUrl)) { image in
                            image.resizable().aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color.gray.opacity(0.1)
                        }
                        .frame(width: 100, height: 80)
                        .cornerRadius(12)
                        .clipped()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(car.fullName)
                                .font(AppTheme.Font.display(size: 18, weight: .bold))
                            Text("\(car.fuel_type) • \(car.transmission)")
                                .font(AppTheme.Font.display(size: 14))
                                .foregroundColor(AppTheme.Color.stone400)
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(20)
                    
                    // Trip Details
                    VStack(alignment: .leading, spacing: 20) {
                        detailRow(icon: "calendar", title: "Dates", value: "\(startDate.formatted(.dateTime.day().month())) - \(endDate.formatted(.dateTime.day().month()))")
                        detailRow(icon: "clock", title: "Duration", value: "\(numberOfDays) Days")
                        detailRow(icon: "mappin.circle", title: "Pickup Location", value: car.city)
                    }
                    .padding(24)
                    .background(Color.white)
                    .cornerRadius(24)
                    
                    // Pricing Breakdown
                    VStack(alignment: .leading, spacing: 20) {
                        Text("FARE BREAKDOWN")
                            .font(AppTheme.Font.display(size: 12, weight: .bold))
                            .foregroundColor(AppTheme.Color.stone400)
                            .tracking(1)
                        
                        pricingRow(title: "Rental Fee", value: "₹\(totalRental)")
                        pricingRow(title: "Security Deposit", value: "₹500")
                        pricingRow(title: "Insurance", value: "FREE", color: .green)
                        
                        Divider()
                        
                        HStack {
                            Text("Total Amount")
                                .font(AppTheme.Font.display(size: 18, weight: .bold))
                            Spacer()
                            Text("₹\(totalRental + 500)")
                                .font(AppTheme.Font.display(size: 22, weight: .bold))
                                .foregroundColor(AppTheme.Color.primary)
                        }
                    }
                    .padding(24)
                    .background(Color.white)
                    .cornerRadius(24)
                    
                    Spacer(minLength: 120)
                }
                .padding(.horizontal, 24)
            }
            
            // Bottom Action
            VStack(spacing: 16) {
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 24)
                }
                
                Button(action: {
                    Task {
                        await viewModel.createBooking(car: car, startDate: startDate, endDate: endDate, dailyRate: car.pricePerDay)
                    }
                }) {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Confirm & Pay")
                        }
                    }
                    .font(AppTheme.Font.display(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .background(Color.black)
                    .cornerRadius(22)
                }
                .disabled(viewModel.isLoading)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.05), radius: 10, y: -5)
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $viewModel.bookingSuccess) {
            BookingSuccessView()
        }
    }
    
    private func detailRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(AppTheme.Color.stone400)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppTheme.Font.display(size: 10, weight: .bold))
                    .foregroundColor(AppTheme.Color.stone400)
                Text(value)
                    .font(AppTheme.Font.display(size: 16, weight: .medium))
            }
        }
    }
    
    private func pricingRow(title: String, value: String, color: Color = .black) -> some View {
        HStack {
            Text(title)
                .font(AppTheme.Font.display(size: 14))
                .foregroundColor(AppTheme.Color.stone500)
            Spacer()
            Text(value)
                .font(AppTheme.Font.display(size: 14, weight: .bold))
                .foregroundColor(color)
        }
    }
}

#Preview {
    BookingSummaryView(car: Car(
        id: UUID(),
        owner_id: UUID(),
        registration_number: "ABC",
        brand: "Tesla",
        model: "Model 3",
        year: 2022,
        fuel_type: "Electric",
        transmission: "Auto",
        seats: 5,
        city: "Mumbai",
        pickup_lat: nil,
        pickup_lng: nil,
        status: "active",
        features: ["Autopilot"],
        created_at: Date(),
        pricing_plans: [PricingPlan(price_per_day: 8000, currency: "INR")],
        car_media: nil
    ), startDate: Date(), endDate: Date().addingTimeInterval(86400 * 3))
}
