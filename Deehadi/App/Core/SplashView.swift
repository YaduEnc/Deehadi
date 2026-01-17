import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZPrincipal {
            AppTheme.Color.backgroundLight
                .ignoresSafeArea()
            
            // Decorative background gradient blur
            Circle()
                .fill(AppTheme.Color.primary.opacity(0.05))
                .frame(width: 500, height: 500)
                .blur(radius: 50)
            
            VStack(spacing: 40) {
                // Logo Section
                ZStack {
                    RoundedRectangle(cornerRadius: 32)
                        .fill(Color.white)
                        .frame(width: 128, height: 128)
                        .shadow(color: AppTheme.Color.primary.opacity(0.05), radius: 20, x: 0, y: 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(Color.black.opacity(0.05), lineWidth: 1)
                        )
                    
                    // Placeholder icon for brand mark
                    Image(systemName: "bolt.car.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 64, height: 64)
                        .foregroundColor(AppTheme.Color.primary)
                    
                    // Decorative accent dot
                    Circle()
                        .fill(AppTheme.Color.primary)
                        .frame(width: 8, height: 8)
                        .offset(x: 32, y: -32)
                        .opacity(isAnimating ? 1 : 0.5)
                        .animation(.easeInOut(duration: 1.5).repeatForever(), value: isAnimating)
                }
                
                // Typography Section
                VStack(spacing: 12) {
                    Text("VELO")
                        .font(AppTheme.Font.display(size: 40, weight: .black))
                        .tracking(10)
                        .foregroundColor(AppTheme.Color.primary)
                    
                    Text("Self-drive cars.\nInsurance included.")
                        .font(AppTheme.Font.display(size: 14, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(AppTheme.Color.stone500)
                        .lineSpacing(4)
                }
            }
            
            // Footer Section
            VStack(spacing: 16) {
                Spacer()
                
                // Minimalist Loader
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(AppTheme.Color.stone200)
                        .frame(width: 96, height: 4)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(AppTheme.Color.primary)
                        .frame(width: 32, height: 4)
                        .offset(x: isAnimating ? 64 : 0)
                        .opacity(0.5)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
                }
                
                Text("TRUSTED BY MILLIONS")
                    .font(AppTheme.Font.display(size: 10, weight: .bold))
                    .kerning(2)
                    .foregroundColor(AppTheme.Color.stone300)
                    .padding(.bottom, 48)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// Helper for centering content
struct ZPrincipal<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            content
        }
    }
}

#Preview {
    SplashView()
}
