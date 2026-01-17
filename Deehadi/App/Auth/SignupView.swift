import SwiftUI

struct SignupView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    // Back
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .padding(12)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                }
                .foregroundColor(.black)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.shield.fill")
                        .foregroundColor(AppTheme.Color.primary)
                    Text("SECURE & INSURED")
                        .font(AppTheme.Font.display(size: 10, weight: .bold))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(AppTheme.Color.primary.opacity(0.1))
                .cornerRadius(20)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    // Title
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Create your account")
                            .font(AppTheme.Font.display(size: 32, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("Join our trusted community of verified drivers and hosts.")
                            .font(AppTheme.Font.display(size: 16))
                            .foregroundColor(AppTheme.Color.stone500)
                    }
                    .padding(.top, 24)
                    
                    // Form
                    VStack(spacing: 24) {
                        // Email
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Email address")
                                .font(AppTheme.Font.display(size: 14, weight: .bold))
                            
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(AppTheme.Color.stone400)
                                TextField("name@example.com", text: $email)
                                if !email.isEmpty && email.contains("@") {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(AppTheme.Color.primary)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.black.opacity(0.05), lineWidth: 1)
                            )
                        }
                        
                        // Password
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Password")
                                .font(AppTheme.Font.display(size: 14, weight: .bold))
                            
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(AppTheme.Color.stone400)
                                if isPasswordVisible {
                                    TextField("Min. 8 characters", text: $password)
                                } else {
                                    SecureField("Min. 8 characters", text: $password)
                                }
                                Button(action: { isPasswordVisible.toggle() }) {
                                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                        .foregroundColor(AppTheme.Color.stone400)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.black.opacity(0.05), lineWidth: 1)
                            )
                        }
                        
                        // Confirm Password
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Confirm Password")
                                .font(AppTheme.Font.display(size: 14, weight: .bold))
                            
                            HStack {
                                Image(systemName: "arrow.clockwise.circle.fill")
                                    .foregroundColor(AppTheme.Color.stone400)
                                if isConfirmPasswordVisible {
                                    TextField("Re-enter password", text: $confirmPassword)
                                } else {
                                    SecureField("Re-enter password", text: $confirmPassword)
                                }
                                Button(action: { isConfirmPasswordVisible.toggle() }) {
                                    Image(systemName: isConfirmPasswordVisible ? "eye.slash" : "eye")
                                        .foregroundColor(AppTheme.Color.stone400)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.black.opacity(0.05), lineWidth: 1)
                            )
                        }
                    }
                    
                    // Disclaimer
                    Text("By selecting \"Create account\", you agree to our [Terms of Service](https://example.com) and acknowledge our [Privacy Policy](https://example.com).")
                        .font(AppTheme.Font.display(size: 12))
                        .foregroundColor(AppTheme.Color.stone500)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }
                .padding(.horizontal, 24)
            }
            
            // Footer Action
            VStack(spacing: 24) {
                Button(action: {
                    // Create Account Action
                }) {
                    HStack {
                        Text("Create account")
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
    SignupView()
}
