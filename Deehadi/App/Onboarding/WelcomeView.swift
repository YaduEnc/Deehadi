import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 0) {
            // Hero Image Section
            ZStack(alignment: .bottom) {
                Image("WelcomeViewCar") // Corrected image name from "velome view car"
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: UIScreen.main.bounds.height * 0.5)
                    .clipped()
                
                // Insurance Badge overlay
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.1))
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
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(Color.white)
                .cornerRadius(24)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                .offset(y: 25) // Halfway over the edge
            }
            .zIndex(1)
            
            VStack(spacing: 40) {
                // Content
                VStack(spacing: 16) {
                    Text("Rent cars with\nconfidence")
                        .font(AppTheme.Font.display(size: 34, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(AppTheme.Color.backgroundDark)
                    
                    Text("Verified cars. Insurance included.\nNo surprises.")
                        .font(AppTheme.Font.display(size: 16, weight: .regular))
                        .multilineTextAlignment(.center)
                        .foregroundColor(AppTheme.Color.stone500)
                        .lineSpacing(4)
                }
                .padding(.top, 60)
                
                Spacer()
                
                // Actions
                VStack(spacing: 24) {
                    NavigationLink(destination: SignupView().navigationBarBackButtonHidden(true)) {
                        HStack {
                            Text("Get started")
                                .font(AppTheme.Font.display(size: 18, weight: .bold))
                            Image(systemName: "arrow.right")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(AppTheme.Color.primary)
                        .foregroundColor(.white)
                        .cornerRadius(20) // Added back cornerRadius
                        .shadow(color: AppTheme.Color.primary.opacity(0.3), radius: 10, y: 5) // Added back shadow
                    }
                    
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .font(AppTheme.Font.display(size: 14))
                            .foregroundColor(AppTheme.Color.stone600)
                        
                        NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                            Text("Log in")
                                .font(AppTheme.Font.display(size: 14, weight: .bold))
                                .foregroundColor(AppTheme.Color.primary)
                        }
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 24) // Added back horizontal padding for actions
            }
            .background(AppTheme.Color.backgroundLight)
        }
        .ignoresSafeArea(edges: .top)
        .background(AppTheme.Color.backgroundLight.ignoresSafeArea())
    }
}

#Preview {
    WelcomeView()
}
