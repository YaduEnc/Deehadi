import SwiftUI

struct HostBookingsView: View {
    @ObservedObject var viewModel: HostViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Booking Requests")
                .font(AppTheme.Font.display(size: 20, weight: .bold))
                .padding(.horizontal, 24)
            
            if viewModel.isLoading && viewModel.incomingBookings.isEmpty {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding(.top, 40)
            } else if viewModel.incomingBookings.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "tray")
                        .font(.system(size: 40))
                        .foregroundColor(AppTheme.Color.stone200)
                    Text("No active requests")
                        .font(AppTheme.Font.display(size: 16, weight: .medium))
                        .foregroundColor(AppTheme.Color.stone400)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 40)
            } else {
                VStack(spacing: 16) {
                    ForEach(viewModel.incomingBookings) { booking in
                        IncomingBookingCard(booking: booking) { status in
                            Task {
                                await viewModel.updateBookingStatus(bookingId: booking.id, status: status)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

struct IncomingBookingCard: View {
    let booking: Booking
    let onAction: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                // Renter Info
                ZStack {
                    Circle().fill(AppTheme.Color.stone100)
                    Image(systemName: "person.fill")
                        .foregroundColor(AppTheme.Color.stone400)
                }
                .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(booking.renter?.full_name ?? "Guest User")
                        .font(AppTheme.Font.display(size: 16, weight: .bold))
                    Text("Requested for \(booking.car?.fullName ?? "Car")")
                        .font(AppTheme.Font.display(size: 12))
                        .foregroundColor(AppTheme.Color.stone400)
                }
                
                Spacer()
                
                Text("₹\(booking.total_amount)")
                    .font(AppTheme.Font.display(size: 16, weight: .bold))
                    .foregroundColor(AppTheme.Color.primary)
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("TRIP DATES")
                        .font(AppTheme.Font.display(size: 10, weight: .bold))
                        .foregroundColor(AppTheme.Color.stone400)
                    Text("\(booking.start_time.formatted(.dateTime.day().month())) - \(booking.end_time.formatted(.dateTime.day().month()))")
                        .font(AppTheme.Font.display(size: 14, weight: .medium))
                }
                
                Spacer()
                
                if booking.status == "pending" {
                    HStack(spacing: 12) {
                        Button(action: { onAction("cancelled") }) {
                            Text("Reject")
                                .font(AppTheme.Font.display(size: 14, weight: .bold))
                                .foregroundColor(.red)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(12)
                        }
                        
                        Button(action: { onAction("active") }) {
                            Text("Accept")
                                .font(AppTheme.Font.display(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.black)
                                .cornerRadius(12)
                        }
                    }
                } else {
                    Text(booking.status.uppercased())
                        .font(AppTheme.Font.display(size: 12, weight: .bold))
                        .foregroundColor(booking.status == "active" ? .green : .gray)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.04), radius: 10, y: 5)
    }
}
