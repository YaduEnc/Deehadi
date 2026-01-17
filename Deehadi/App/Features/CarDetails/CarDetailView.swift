import SwiftUI
import Auth

struct CarDetailView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = CarDetailViewModel()
    @EnvironmentObject var session: UserSession
    
    let car: Car
    
    var isOwner: Bool {
        session.session?.user.id == car.owner_id
    }
    
    // State for booking date (placeholder for now)
    @State private var bookingStart = Date()
    @State private var bookingEnd = Calendar.current.date(byAdding: .day, value: 3, to: Date())!
    @State private var showEditSheet = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AppTheme.Color.backgroundLight.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Hero Section
                    heroSection
                    
                    VStack(spacing: 24) {
                        // Title & Info
                        headerInfoSection
                        
                        // Specifications
                        specificationsSection
                        
                        // Features
                        if let features = car.features, !features.isEmpty {
                            featuresSection(features: features)
                        }
                        
                        // Host Info
                        hostInfoSection
                        
                        if !isOwner {
                            // Booking Dates
                            bookingDetailsSection
                            
                            // Pricing
                            pricingSection
                        }
                        
                        // Bottom Pad for Button
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                }
            }
            .ignoresSafeArea(edges: .top)
            
            // Bottom Action
            bottomFixedButton
        }
        .navigationBarHidden(true)
        .onAppear {
            Task {
                await viewModel.fetchOwnerProfile(ownerId: car.owner_id)
            }
        }
        .sheet(isPresented: $showEditSheet) {
            let editVM = HostViewModel()
            AddCarView(viewModel: editVM)
                .onAppear {
                    editVM.prepareForEdit(car: car)
                }
        }
    }
    
    // MARK: - Components
    
    private var heroSection: some View {
        ZStack(alignment: .top) {
            // Image Carousel (Placeholder logic)
            TabView {
                AsyncImage(url: URL(string: car.imageUrl)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle().fill(Color.gray.opacity(0.1))
                }
                
                // Demo extra slide
                Color.black.opacity(0.8)
            }
            .frame(height: 350)
            .tabViewStyle(PageTabViewStyle())
            
            // Top Nav
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(BlurView(style: .systemThinMaterialDark))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(AppTheme.Color.primary)
                        .frame(width: 44, height: 44)
                        .background(BlurView(style: .systemThinMaterialDark))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 60)
        }
    }
    
    private var headerInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                TagLabel(text: "INSURANCE INCLUDED", icon: "checkmark.shield.fill", color: Color(hex: "E8F5E9"), textColor: Color(hex: "2E7D32"))
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill").foregroundColor(.orange).font(.system(size: 14))
                    Text(car.rating > 0 ? String(format: "%.1f", car.rating) : "New")
                        .font(AppTheme.Font.display(size: 16, weight: .bold))
                    Text("(\(car.tripsCount))")
                        .font(AppTheme.Font.display(size: 14))
                        .foregroundColor(AppTheme.Color.stone400)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(car.fullName)
                    .font(AppTheme.Font.display(size: 28, weight: .bold))
                Text("PREMIUM \(car.fuel_type.uppercased()) • \(car.year)")
                    .font(AppTheme.Font.display(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.Color.stone400)
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .offset(y: -40)
        .padding(.bottom, -40)
    }
    
    private var specificationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("SPECIFICATIONS")
                .font(AppTheme.Font.display(size: 12, weight: .bold))
                .foregroundColor(AppTheme.Color.stone400)
                .tracking(1)
            
            HStack(spacing: 12) {
                SpecCard(icon: "gearshape.2.fill", title: "Automatic") // Logic needed
                SpecCard(icon: "fuelpump.fill", title: car.fuel_type)
                SpecCard(icon: "person.2.fill", title: "\(car.seats) Seats")
            }
        }
    }
    
    private func featuresSection(features: [String]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("FEATURES")
                .font(AppTheme.Font.display(size: 12, weight: .bold))
                .foregroundColor(AppTheme.Color.stone400)
                .tracking(1)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(features, id: \.self) { feature in
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(AppTheme.Color.primary)
                        Text(feature)
                            .font(AppTheme.Font.display(size: 14))
                            .foregroundColor(AppTheme.Color.textPrimary)
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppTheme.Color.stone100, lineWidth: 1)
                    )
                }
            }
        }
    }
    
    private var hostInfoSection: some View {
        HStack(spacing: 16) {
            ZStack(alignment: .bottomTrailing) {
                Image(systemName: "person.circle.fill") // Placeholder host image
                    .resizable()
                    .frame(width: 56, height: 56)
                    .foregroundColor(AppTheme.Color.stone200)
                
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(AppTheme.Color.primary)
                    .background(Circle().fill(.white))
                    .offset(x: 2, y: 2)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("OWNED BY")
                    .font(AppTheme.Font.display(size: 10, weight: .bold))
                    .foregroundColor(AppTheme.Color.stone400)
                Text(viewModel.ownerProfile?.full_name ?? "Loading...")
                    .font(AppTheme.Font.display(size: 16, weight: .bold))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill").foregroundColor(.orange).font(.system(size: 12))
                    Text(viewModel.ownerProfile != nil ? "5.0" : "-").font(AppTheme.Font.display(size: 14, weight: .bold))
                }
                Text("Instant reply")
                    .font(AppTheme.Font.display(size: 12))
                    .foregroundColor(AppTheme.Color.stone400)
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
    }
    
    private var bookingDetailsSection: some View {
        let numberOfDays = Calendar.current.dateComponents([.day], from: bookingStart, to: bookingEnd).day ?? 1
        return VStack(alignment: .leading, spacing: 16) {
            Text("BOOKING DETAILS")
                .font(AppTheme.Font.display(size: 12, weight: .bold))
                .foregroundColor(AppTheme.Color.stone400)
                .tracking(1)
            
            HStack {
                DatePicker("", selection: $bookingStart, displayedComponents: .date)
                    .labelsHidden()
                Text("-")
                DatePicker("", selection: $bookingEnd, displayedComponents: .date)
                    .labelsHidden()
                
                Spacer()
                
                Text("\(numberOfDays) days")
                    .font(AppTheme.Font.display(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.Color.stone500)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .background(AppTheme.Color.stone100)
                    .cornerRadius(16)
            }
        }
    }
    
    private var pricingSection: some View {
        let numberOfDays = max(1, Calendar.current.dateComponents([.day], from: bookingStart, to: bookingEnd).day ?? 1)
        let totalRental = car.pricePerDay * numberOfDays
        
        return VStack(alignment: .leading, spacing: 16) {
            Text("PRICING")
                .font(AppTheme.Font.display(size: 12, weight: .bold))
                .foregroundColor(AppTheme.Color.stone400)
                .tracking(1)
            
            VStack(spacing: 12) {
                pricingRow(title: "Daily Rate (₹\(car.pricePerDay) x \(numberOfDays))", value: "₹\(totalRental).00")
                
                HStack {
                    Text("Insurance")
                        .font(AppTheme.Font.display(size: 14))
                        .foregroundColor(AppTheme.Color.stone500)
                    Text("INCL.")
                        .font(AppTheme.Font.display(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(hex: "2E7D32"))
                        .cornerRadius(4)
                    Spacer()
                    Text("₹0.00")
                        .font(AppTheme.Font.display(size: 14, weight: .bold))
                        .foregroundColor(Color(hex: "2E7D32"))
                }
                
                pricingRow(title: "Security Deposit (Refundable)", value: "₹500.00")
                
                Divider()
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        Text("TOTAL AMOUNT")
                            .font(AppTheme.Font.display(size: 10, weight: .bold))
                            .foregroundColor(AppTheme.Color.stone400)
                        Text("₹\(totalRental + 500).00")
                            .font(AppTheme.Font.display(size: 24, weight: .bold))
                    }
                    Spacer()
                    Text("Excl. deposit")
                        .font(AppTheme.Font.display(size: 10))
                        .italic()
                        .foregroundColor(AppTheme.Color.stone300)
                }
            }
        }
    }
    
    private func pricingRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(AppTheme.Font.display(size: 14))
                .foregroundColor(AppTheme.Color.stone500)
            Spacer()
            Text(value)
                .font(AppTheme.Font.display(size: 14, weight: .bold))
        }
    }
    
    private var bottomFixedButton: some View {
        Group {
            if isOwner {
                VStack {
                    HStack(spacing: 16) {
                        Button(action: {
                            // Create a temporary VM for editing just like in HostDashboard
                            // For simplicity, we can use a callback or just initialize the sheet's VM
                            showEditSheet = true
                        }) {
                            Text("Edit listing")
                                .font(AppTheme.Font.display(size: 16, weight: .bold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(AppTheme.Color.stone100)
                                .cornerRadius(18)
                        }
                        
                        Button(action: {
                            // Action: Share
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(Color(hex: "2D2D2D"))
                                .cornerRadius(18)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    .padding(.top, 16)
                }
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: -5)
            } else {
                VStack {
                    NavigationLink(destination: BookingSummaryView(car: car, startDate: bookingStart, endDate: bookingEnd)) {
                        Text("Book now")
                            .font(AppTheme.Font.display(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 64)
                            .background(Color(hex: "2D2D2D"))
                            .cornerRadius(22)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    .padding(.top, 16)
                }
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: -5)
            }
        }
    }
}

struct SpecCard: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(AppTheme.Color.stone400)
            Text(title)
                .font(AppTheme.Font.display(size: 14, weight: .bold))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(Color.white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
    }
}

#Preview {
    CarDetailView(car: Car(
        id: UUID(),
        owner_id: UUID(),
        registration_number: "123",
        brand: "Mercedes-Benz",
        model: "C-Class",
        year: 2023,
        fuel_type: "Petrol",
        transmission: "Automatic",
        seats: 5,
        city: "Mumbai",
        pickup_lat: 0,
        pickup_lng: 0,
        status: "active",
        features: ["Air Conditioning", "Bluetooth", "Music System"],
        created_at: Date(),
        pricing_plans: [PricingPlan(price_per_day: 5000, currency: "INR")],
        car_media: nil
    ))
}
