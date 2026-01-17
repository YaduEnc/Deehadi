import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    // Dismiss
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black)
                }
                Spacer()
                Button("Help") {
                    // Help action
                }
                .font(AppTheme.Font.display(size: 14, weight: .medium))
                .foregroundColor(AppTheme.Color.primary)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    // Title
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Welcome back")
                            .font(AppTheme.Font.display(size: 32, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("Sign in to access your rentals and insurance.")
                            .font(AppTheme.Font.display(size: 16))
                            .foregroundColor(AppTheme.Color.stone500)
                    }
                    .padding(.top, 24)
                    
                    // Google Auth
                    Button(action: {
                        // Google Login
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "person.crop.circle.fill") // Google icon placeholder
                            Text("Continue with Google")
                                .font(AppTheme.Font.display(size: 16, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.black.opacity(0.1), lineWidth: 1)
                        )
                    }
                    
                    // Divider
                    HStack {
                        Rectangle().fill(Color.black.opacity(0.05)).frame(height: 1)
                        Text("or")
                            .font(AppTheme.Font.display(size: 14))
                            .foregroundColor(AppTheme.Color.stone400)
                            .padding(.horizontal, 8)
                        Rectangle().fill(Color.black.opacity(0.05)).frame(height: 1)
                    }
                    
                    // Form
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Email address")
                                .font(AppTheme.Font.display(size: 14, weight: .bold))
                            
                            TextField("Enter your email", text: $email)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.black.opacity(0.1), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Password")
                                    .font(AppTheme.Font.display(size: 14, weight: .bold))
                                Spacer()
                                Button("Forgot?") {
                                    // Forgot password
                                }
                                .font(AppTheme.Font.display(size: 12, weight: .bold))
                                .foregroundColor(AppTheme.Color.primary)
                            }
                            
                            HStack {
                                if isPasswordVisible {
                                    TextField("Enter your password", text: $password)
                                } else {
                                    SecureField("Enter your password", text: $password)
                                }
                                
                                Button(action: {
                                    isPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                        .foregroundColor(AppTheme.Color.stone500)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.black.opacity(0.1), lineWidth: 1)
                            )
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            
            // Footer Action
            VStack(spacing: 24) {
                HStack {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 12))
                    Text("SECURE 256-BIT ENCRYPTION")
                        .font(AppTheme.Font.display(size: 10, weight: .bold))
                }
                .foregroundColor(AppTheme.Color.stone400)
                
                Button(action: {
                    // Continue Login
                }) {
                    HStack {
                        Text("Continue")
                            .font(AppTheme.Font.display(size: 18, weight: .bold))
                        Image(systemName: "arrow.right")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(AppTheme.Color.primary)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                }
                
                HStack(spacing: 4) {
                    Text("Don’t have an account?")
                        .font(AppTheme.Font.display(size: 14))
                        .foregroundColor(AppTheme.Color.stone600)
                    
                    Button("Create an account") {
                        // Go to signup
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
    LoginView()
}
