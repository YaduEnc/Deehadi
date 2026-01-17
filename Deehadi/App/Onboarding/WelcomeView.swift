import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 32) {
            // Top Bar
//            HStack {
//                Spacer()
//                ZStack {
//                    Circle()
//                        .fill(AppTheme.Color.primary.opacity(0.1))
//                        .frame(width: 48, height: 48)
//                    
//                    Image(systemName: "key.fill")
//                        .foregroundColor(AppTheme.Color.primary)
//                }
//                Spacer()
//            }
//            .padding(.top, 16)
            
            // Hero Image Section
            ZStack(alignment: .bottom) {
                // Hero Image
                Image("velome view car")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 48))
                
                // Insurance Badge overlay
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.2))
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("INSURANCE")
                            .font(AppTheme.Font.display(size: 10, weight: .bold))
                            .foregroundColor(.black)
                        Text("Full coverage active")
                            .font(AppTheme.Font.display(size: 10, weight: .regular))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white.opacity(0.9))
                .cornerRadius(20)
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 24)
            
            // Content
            VStack(spacing: 16) {
                Text("Rent cars with\nconfidence")
                    .font(AppTheme.Font.display(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(AppTheme.Color.backgroundDark)
                
                Text("Verified cars. Insurance included.\nNo surprises.")
                    .font(AppTheme.Font.display(size: 16, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundColor(AppTheme.Color.stone500)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Actions
            VStack(spacing: 20) {
                Button(action: {
                    // Start onboarding/signup
                }) {
                    HStack {
                        Text("Get started")
                            .font(AppTheme.Font.display(size: 18, weight: .bold))
                        Image(systemName: "arrow.right")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(AppTheme.Color.primary)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .shadow(color: AppTheme.Color.primary.opacity(0.3), radius: 10, y: 5)
                }
                
                HStack(spacing: 4) {
                    Text("Already have an account?")
                        .font(AppTheme.Font.display(size: 14))
                        .foregroundColor(AppTheme.Color.stone600)
                    
                    Button("Log in") {
                        // Go to login
                    }
                    .font(AppTheme.Font.display(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.Color.primary)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(AppTheme.Color.backgroundLight.ignoresSafeArea())
    }
}

#Preview {
    WelcomeView()
}
