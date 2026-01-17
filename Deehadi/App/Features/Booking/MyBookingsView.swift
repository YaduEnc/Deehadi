import SwiftUI

struct MyBookingsView: View {
    @StateObject private var viewModel = MyBookingsViewModel()
    @State private var selectedFilter = 0 // 0: Upcoming, 1: Past
    
    var body: some View {
        ZStack {
            AppTheme.Color.backgroundLight.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Header
                HStack {
                    Text("My Bookings")
                        .font(AppTheme.Font.display(size: 28, weight: .bold))
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 16)
                
                // Segmented Picker
                HStack(spacing: 0) {
                    FilterButton(title: "Upcoming", isSelected: selectedFilter == 0) {
                        selectedFilter = 0
                    }
                    FilterButton(title: "Past Trips", isSelected: selectedFilter == 1) {
                        selectedFilter = 1
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                
                // Content
                ScrollView(showsIndicators: false) {
                    if viewModel.isLoading {
                        ProgressView()
                            .padding(.top, 40)
                    } else if (selectedFilter == 0 ? viewModel.upcomingBookings : viewModel.pastBookings).isEmpty {
                        emptyState
                    } else {
                        VStack(spacing: 20) {
                            ForEach(selectedFilter == 0 ? viewModel.upcomingBookings : viewModel.pastBookings) { booking in
                                BookingCard(booking: booking)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                    }
                }
                .refreshable {
                    await viewModel.fetchBookings()
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchBookings()
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.Color.stone200)
                .padding(.top, 60)
            
            Text(selectedFilter == 0 ? "No upcoming trips" : "No past trips found")
                .font(AppTheme.Font.display(size: 18, weight: .bold))
                .foregroundColor(AppTheme.Color.stone400)
            
            Text(selectedFilter == 0 ? "You haven't booked any rides yet. Explore cars to start your journey!" : "")
                .font(AppTheme.Font.display(size: 14))
                .foregroundColor(AppTheme.Color.stone400)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(AppTheme.Font.display(size: 16, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? .black : AppTheme.Color.stone400)
                
                Rectangle()
                    .fill(isSelected ? AppTheme.Color.primary : Color.clear)
                    .frame(height: 3)
                    .cornerRadius(2)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct BookingCard: View {
    let booking: Booking
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 16) {
                // Car Image
                if let car = booking.car {
                    AsyncImage(url: URL(string: car.imageUrl)) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray.opacity(0.1)
                    }
                    .frame(width: 80, height: 80)
                    .cornerRadius(12)
                    .clipped()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(car.fullName)
                                .font(AppTheme.Font.display(size: 16, weight: .bold))
                            Spacer()
                            statusBadge(status: booking.status)
                        }
                        
                        Text("\(booking.start_time.formatted(.dateTime.day().month().year()))")
                            .font(AppTheme.Font.display(size: 14))
                            .foregroundColor(AppTheme.Color.stone400)
                        
                        Text("Total: ₹\(booking.total_amount)")
                            .font(AppTheme.Font.display(size: 14, weight: .bold))
                            .foregroundColor(AppTheme.Color.primary)
                    }
                }
            }
            .padding(16)
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
    }
    
    private func statusBadge(status: String) -> some View {
        Text(status.uppercased())
            .font(AppTheme.Font.display(size: 8, weight: .bold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor(status).opacity(0.1))
            .foregroundColor(statusColor(status))
            .clipShape(Capsule())
    }
    
    private func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "pending": return .orange
        case "active": return .blue
        case "completed": return .green
        case "cancelled": return .red
        default: return .gray
        }
    }
}

#Preview {
    MyBookingsView()
}
