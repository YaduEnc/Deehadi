import SwiftUI

struct BookingSuccessView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            AppTheme.Color.backgroundLight.ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Animated Checkmark (Simple version)
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.1))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.green)
                }
                
                VStack(spacing: 12) {
                    Text("Booking Confirmed!")
                        .font(AppTheme.Font.display(size: 28, weight: .bold))
                    
                    Text("Your ride is scheduled. You can view trip details in your Bookings tab.")
                        .font(AppTheme.Font.display(size: 16))
                        .foregroundColor(AppTheme.Color.stone500)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
                Button(action: {
                    // This should ideally navigate back to Home or Bookings tab
                    // For now, let's just dismiss this fullScreenCover
                    dismiss()
                }) {
                    Text("Back to Home")
                        .font(AppTheme.Font.display(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.black)
                        .cornerRadius(20)
                }
                .padding(24)
            }
        }
    }
}

#Preview {
    BookingSuccessView()
}
