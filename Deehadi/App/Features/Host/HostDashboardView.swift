import SwiftUI

struct HostDashboardView: View {
    @StateObject private var viewModel = HostViewModel()
    @State private var showingAddCar = false
    @State private var showRequests = false
    @State private var showKYC = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.Color.backgroundLight.ignoresSafeArea()
                
                if viewModel.isLoading && viewModel.myCars.isEmpty && viewModel.incomingBookings.isEmpty {
                    ProgressView()
                } else if viewModel.myCars.isEmpty && !showRequests { // Only show empty state if no cars and not viewing requests
                    emptyStateView
                } else {
                    activeListingsView
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                Task {
                    await viewModel.checkKYCStatus()
                    await viewModel.fetchMyCars()
                    await viewModel.fetchIncomingBookings()
                }
            }
            .sheet(isPresented: $showKYC) {
                KYCView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingAddCar) {
                // Determine if we show KYC or AddCar
                if viewModel.kycStatus == .verified {
                    AddCarView(viewModel: viewModel)
                } else {
                    KYCView(viewModel: viewModel)
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "car.side.fill") // Placeholder for the car outline image
                .font(.system(size: 80))
                .foregroundColor(AppTheme.Color.stone200)
            
            VStack(spacing: 8) {
                Text("You haven't listed any cars yet")
                    .font(AppTheme.Font.display(size: 20, weight: .bold))
                    .foregroundColor(AppTheme.Color.textPrimary)
                
                Text("List your car and start earning.")
                    .font(AppTheme.Font.display(size: 16))
                    .foregroundColor(AppTheme.Color.stone500)
            }
            
            Button(action: {
                // Check KYC triggers
                if viewModel.kycStatus == .verified {
                    showingAddCar = true 
                } else {
                    showKYC = true
                }
            }) {
                Text("Add your car")
                    .font(AppTheme.Font.display(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(Color(hex: "2D2D2D"))
                    .cornerRadius(12)
            }
            .padding(.top, 16)
            
            Spacer()
        }
        .padding(24)
        .navigationTitle("Host Dashboard")
    }
    
    private var activeListingsView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header and Toggle
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your Fleet")
                            .font(AppTheme.Font.display(size: 28, weight: .bold))
                        Text("Manage your fleet & requests")
                            .font(AppTheme.Font.display(size: 14))
                            .foregroundColor(AppTheme.Color.stone400)
                    }
                    
                    Spacer()
                    
                    // Requests Toggle
                    Button(action: { showRequests.toggle() }) {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: showRequests ? "car.2.fill" : "bell.badge.fill")
                                .font(.system(size: 20))
                                .foregroundColor(AppTheme.Color.primary)
                                .frame(width: 44, height: 44)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.05), radius: 10)
                            
                            if !viewModel.incomingBookings.filter({ $0.status == "pending" }).isEmpty && !showRequests {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 10, height: 10)
                                    .offset(x: -8, y: 8)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                // Earnings Card
                VStack(alignment: .leading, spacing: 8) {
                    Text("TOTAL EARNINGS")
                        .font(AppTheme.Font.display(size: 10, weight: .bold))
                        .foregroundColor(AppTheme.Color.stone400)
                        .tracking(1)
                    Text("₹\(String(format: "%.2f", viewModel.totalEarnings))")
                        .font(AppTheme.Font.display(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    HStack {
                        Image(systemName: "arrow.up.right")
                        Text("+12.5% from last month")
                    }
                    .font(AppTheme.Font.display(size: 12))
                    .foregroundColor(Color(hex: "E3FCEF"))
                    .padding(.top, 4)
                }
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(hex: "2D2D2D"))
                .cornerRadius(24)
                .padding(.horizontal, 24)
                
                if showRequests {
                    HostBookingsView(viewModel: viewModel)
                        .padding(.top, 8)
                } else {
                    // My Cars Section
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Your Cars")
                            .font(AppTheme.Font.display(size: 20, weight: .bold))
                            .padding(.horizontal, 24)
                        
                        if viewModel.isLoading && viewModel.myCars.isEmpty {
                            ProgressView()
                                .padding(.top, 40)
                                .frame(maxWidth: .infinity)
                        } else if viewModel.myCars.isEmpty {
                            emptyCarsState
                        } else {
                            ForEach(viewModel.myCars) { car in
                                NavigationLink(destination: CarDetailView(car: car)) {
                                    HostCarCard(car: car)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 100)
        }
        .overlay(
            Button(action: { showingAddCar = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add your car")
                }
                .font(AppTheme.Font.display(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color(hex: "2D2D2D"))
                .cornerRadius(30)
                .shadow(color: Color.black.opacity(0.15), radius: 10, y: 5)
            }
            .padding(.bottom, 24)
            , alignment: .bottom
        )
    }
    
    private var emptyCarsState: some View {
        VStack(spacing: 16) {
            Image(systemName: "car.fill")
                .font(.system(size: 50))
                .foregroundColor(AppTheme.Color.stone200)
            Text("No cars listed yet.")
                .font(AppTheme.Font.display(size: 18, weight: .medium))
                .foregroundColor(AppTheme.Color.textPrimary)
            Text("Add your first car to start earning.")
                .font(AppTheme.Font.display(size: 14))
                .foregroundColor(AppTheme.Color.stone500)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

struct HostCarCard: View {
    let car: Car
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: car.imageUrl)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ZStack {
                        Color.gray.opacity(0.1)
                        ProgressView()
                    }
                }
                .frame(height: 180)
                .clipped()
                
                TagLabel(text: car.status.uppercased(), icon: nil, color: Color(hex: "E8F5E9"), textColor: Color(hex: "2E7D32"))
                    .padding(12)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(car.fullName)
                            .font(AppTheme.Font.display(size: 18, weight: .bold))
                            .foregroundColor(.black)
                        Text("\(car.brand) • \(car.year)")
                            .font(AppTheme.Font.display(size: 14))
                            .foregroundColor(AppTheme.Color.stone500)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("TOTAL EARNINGS")
                            .font(AppTheme.Font.display(size: 8, weight: .bold))
                            .foregroundColor(AppTheme.Color.stone400)
                        Text("₹1,240") // Placeholder for now
                            .font(AppTheme.Font.display(size: 16, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
                
                Divider()
                
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "eye.fill")
                        Text("284")
                    }
                    .font(AppTheme.Font.display(size: 12))
                    .foregroundColor(AppTheme.Color.stone400)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Text("Details")
                        Image(systemName: "chevron.right")
                    }
                    .font(AppTheme.Font.display(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.Color.primary)
                }
            }
            .padding(16)
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 24)
    }
}

#Preview {
    HostDashboardView()
}
