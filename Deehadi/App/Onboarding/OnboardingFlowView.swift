import SwiftUI
import Supabase
struct OnboardingFlowView: View {
    @State private var currentStep = 0
    @EnvironmentObject var session: UserSession
    
    // Form fields
    @State private var selectedRole = "renter"
    @State private var fullName = ""
    @State private var dob = Date()
    
    var body: some View {
        VStack {
            if currentStep < 3 {
                WalkthroughView(step: $currentStep)
            } else if currentStep == 3 {
                AppUsageView(selectedRole: $selectedRole, next: { currentStep += 1 })
            } else {
                ProfileSetupView(fullName: $fullName, dob: $dob, finish: finishSetup)
            }
        }
        .animation(.default, value: currentStep)
    }
    
    func finishSetup() {
        Task {
            guard let userId = session.session?.user.id else { return }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dobString = dateFormatter.string(from: dob)
            
            let updatedProfile = UserProfile(
                id: userId,
                full_name: fullName,
                dob: dobString,
                profile_photo_url: nil,
                phone_number: nil,
                is_owner: selectedRole == "owner" || selectedRole == "both",
                address: nil, city: nil, state: nil, pincode: nil,
                onboarding_completed: true
            )
            
            do {
                try await SupabaseManager.shared.client
                    .from("user_profiles")
                    .update(updatedProfile)
                    .eq("id", value: userId)
                    .execute()
                
                await session.fetchProfile()
            } catch {
                print("Error updating profile: \(error)")
            }
        }
    }
}

// MARK: - Subviews

struct WalkthroughView: View {
    @Binding var step: Int
    
    var body: some View {
        ZStack(alignment: .top) {
            AppTheme.Color.backgroundLight.ignoresSafeArea()
            
            // Content Switcher
            Group {
                if step == 0 {
                    Step1View(next: { step += 1 })
                } else if step == 1 {
                    Step2View(next: { step += 1 })
                } else if step == 2 {
                    Step3View(next: { step += 1 })
                }
            }
            .transition(.asymmetric(
                insertion: .opacity.combined(with: .move(edge: .trailing)),
                removal: .opacity.combined(with: .move(edge: .leading))
            ))
            
            // Overlaid Header with Skip (Always on top)
            HStack {
                Spacer()
                Button(action: { step = 3 }) {
                    Text("Skip")
                        .font(AppTheme.Font.display(size: 14, weight: .bold))
                        .foregroundColor(.black.opacity(0.6))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(BlurView(style: .systemThinMaterialLight).opacity(0.8))
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
        }
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct Step1View: View {
    var next: () -> Void
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                // 1. Hero Image Case (Extended to 75% to eliminate gap)
                ZStack(alignment: .bottom) {
                    Image("Onb1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.height * 0.75)
                        .clipped()
                    
                    // Smooth gradient overlay for readability
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.3)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 100)
                }
                .ignoresSafeArea(edges: .top)
                
                // 2. White Card (Emerging from bottom)
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 0) {
                        // Grabber Indicator
                        RoundedRectangle(cornerRadius: 3)
                            .fill(AppTheme.Color.stone200)
                            .frame(width: 36, height: 5)
                            .padding(.top, 12)
                        
                        VStack(spacing: 24) {
                            // Text Content
                            VStack(spacing: 12) {
                                Text("Drive without worry")
                                    .font(AppTheme.Font.display(size: 28, weight: .bold))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                
                                Text("Every trip comes with\ncomprehensive insurance &\nprotection.")
                                    .font(AppTheme.Font.display(size: 16))
                                    .lineSpacing(4)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(AppTheme.Color.stone500)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            
                            // Pagination Dots
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(AppTheme.Color.primary)
                                    .frame(width: 8, height: 8)
                                Circle()
                                    .fill(AppTheme.Color.stone200)
                                    .frame(width: 8, height: 8)
                                Circle()
                                    .fill(AppTheme.Color.stone200)
                                    .frame(width: 8, height: 8)
                            }
                            
                            // Primary CTA
                            Button(action: next) {
                                HStack(spacing: 8) {
                                    Text("Next")
                                    Image(systemName: "arrow.right")
                                }
                                .font(AppTheme.Font.display(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(AppTheme.Color.primary)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .shadow(color: AppTheme.Color.primary.opacity(0.3), radius: 10, x: 0, y: 5)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 32)
                        .padding(.bottom, geo.safeAreaInsets.bottom + 20)
                    }
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedCorner(radius: 40, corners: [.topLeft, .topRight])
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: -5)
                    )
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
    }
}

struct Step2View: View {
    var next: () -> Void
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 20)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Simple.\nTransparent.")
                    .font(AppTheme.Font.display(size: 32, weight: .bold))
                    .foregroundColor(.black)
                Text("Secure.")
                    .font(AppTheme.Font.display(size: 32, weight: .bold))
                    .foregroundColor(AppTheme.Color.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)
            
            Spacer(minLength: 40)
            
            VStack(spacing: 16) {
                BenefitRow(icon: "car.fill", title: "Choose a car", subtitle: "Browse thousands of verified local hosts.")
                BenefitRow(icon: "shield.fill", title: "Drive safely", subtitle: "Comprehensive insurance is included.")
                BenefitRow(icon: "arrow.uturn.backward", title: "Return & relax", subtitle: "Easy drop-off with automated check-out.")
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            Button(action: next) {
                HStack(spacing: 8) {
                    Text("Next step")
                    Image(systemName: "arrow.right")
                }
                .font(AppTheme.Font.display(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(AppTheme.Color.primary)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .shadow(color: AppTheme.Color.primary.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
    }
}

struct Step3View: View {
    var next: () -> Void
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 40)
            
            ZStack {
                Circle()
                    .fill(AppTheme.Color.primary.opacity(0.1))
                    .frame(width: 220, height: 220)
                
                Image(systemName: "shield.safe.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .foregroundColor(AppTheme.Color.primary)
                    .shadow(color: AppTheme.Color.primary.opacity(0.2), radius: 15, x: 0, y: 10)
            }
            
            Spacer(minLength: 40)
            
            VStack(spacing: 16) {
                Text("Insurance included\non every trip")
                    .font(AppTheme.Font.display(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                
                Text("Accidents, damage, theft — covered.\nYour liability is capped.")
                    .font(AppTheme.Font.display(size: 17))
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
                    .foregroundColor(AppTheme.Color.stone500)
            }
            .padding(.horizontal, 32)
            
            Spacer(minLength: 32)
            
            HStack(spacing: 12) {
                TagView(icon: "checkmark.shield.fill", text: "CAPPED LIABILITY")
                TagView(icon: "headphones", text: "24/7 SUPPORT")
            }
            
            Spacer()
            
            Button(action: next) {
                HStack(spacing: 8) {
                    Text("Continue")
                    Image(systemName: "arrow.right")
                }
                .font(AppTheme.Font.display(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(AppTheme.Color.primary)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .shadow(color: AppTheme.Color.primary.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
    }
}

struct AppUsageView: View {
    @Binding var selectedRole: String
    var next: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {}) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(12)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.05), radius: 10)
            }
            .padding(.top, 16)
            
            Spacer(minLength: 32)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("How will you use the\napp?")
                    .font(AppTheme.Font.display(size: 32, weight: .bold))
                    .foregroundColor(.black)
                
                Text("Choose your primary goal to verify your insurance eligibility.")
                    .font(AppTheme.Font.display(size: 16))
                    .foregroundColor(AppTheme.Color.stone500)
                    .lineSpacing(4)
            }
            
            Spacer(minLength: 40)
            
            VStack(spacing: 16) {
                UsageOptionRow(icon: "car.fill", title: "Rent cars", subtitle: "Browse premium cars near you", isSelected: selectedRole == "renter") { selectedRole = "renter" }
                UsageOptionRow(icon: "house.fill", title: "List my car", subtitle: "Earn with full insurance coverage", isSelected: selectedRole == "owner") { selectedRole = "owner" }
                UsageOptionRow(icon: "person.2.fill", title: "Both", subtitle: "Explore rentals and manage listings", isSelected: selectedRole == "both") { selectedRole = "both" }
            }
            
            Spacer()
            
            Button("Continue", action: next)
                .font(AppTheme.Font.display(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(AppTheme.Color.primary)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .shadow(color: AppTheme.Color.primary.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding(24)
        .background(AppTheme.Color.backgroundLight.ignoresSafeArea())
    }
}

struct ProfileSetupView: View {
    @Binding var fullName: String
    @Binding var dob: Date
    var finish: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Button(action: {}) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Step 1 of 3")
                    .font(AppTheme.Font.display(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.Color.stone400)
                Spacer()
                Button("Help") {}
                    .font(AppTheme.Font.display(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.Color.primary)
            }
            .padding(.top, 16)
            
            Spacer(minLength: 32)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Tell us about you")
                    .font(AppTheme.Font.display(size: 32, weight: .bold))
                    .foregroundColor(.black)
                
                Text("We need your legal name and birth date to activate your insurance protection.")
                    .font(AppTheme.Font.display(size: 16))
                    .foregroundColor(AppTheme.Color.stone500)
                    .lineSpacing(4)
            }
            
            Spacer(minLength: 40)
            
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("LEGAL FULL NAME")
                        .font(AppTheme.Font.display(size: 12, weight: .bold))
                        .foregroundColor(AppTheme.Color.stone400)
                        .tracking(1)
                    
                    TextField("e.g. Jane Doe", text: $fullName)
                        .font(AppTheme.Font.display(size: 16, weight: .medium))
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.black.opacity(0.05), lineWidth: 1)
                        )
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("DATE OF BIRTH")
                        .font(AppTheme.Font.display(size: 12, weight: .bold))
                        .foregroundColor(AppTheme.Color.stone400)
                        .tracking(1)
                    
                    DatePicker("", selection: $dob, displayedComponents: .date)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color.black.opacity(0.05), lineWidth: 1)
                        )
                }
            }
            
            Spacer()
            
            Button("Finish Setup", action: finish)
                .font(AppTheme.Font.display(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(AppTheme.Color.primary)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .shadow(color: AppTheme.Color.primary.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding(24)
        .background(AppTheme.Color.backgroundLight.ignoresSafeArea())
    }
}

// MARK: - Helper Components

struct BenefitRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle().fill(AppTheme.Color.stone50).frame(width: 48, height: 48)
                Image(systemName: icon).foregroundColor(AppTheme.Color.primary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(AppTheme.Font.display(size: 16, weight: .bold))
                Text(subtitle).font(AppTheme.Font.display(size: 14)).foregroundColor(AppTheme.Color.stone500)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 6)
        )
    }
}

struct UsageOptionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle().fill(AppTheme.Color.stone50).frame(width: 48, height: 48)
                    Image(systemName: icon).foregroundColor(AppTheme.Color.primary)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title).font(AppTheme.Font.display(size: 16, weight: .bold))
                        .foregroundColor(.black)
                    Text(subtitle).font(AppTheme.Font.display(size: 14)).foregroundColor(AppTheme.Color.stone500)
                }
                
                Spacer()
                
                if isSelected {
                    ZStack {
                        Circle().fill(AppTheme.Color.primary).frame(width: 24, height: 24)
                        Image(systemName: "checkmark").font(.system(size: 12, weight: .bold)).foregroundColor(.white)
                    }
                } else {
                    Circle().stroke(AppTheme.Color.stone200, lineWidth: 2).frame(width: 24, height: 24)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(isSelected ? AppTheme.Color.primary : Color.clear, lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(isSelected ? 0.05 : 0.02), radius: 10, x: 0, y: 5)
        }
    }
}

struct TagView: View {
    let icon: String
    let text: String
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon).font(.system(size: 12))
            Text(text).font(AppTheme.Font.display(size: 10, weight: .bold))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black.opacity(0.05)))
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
struct OnboardingFlowView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFlowView()
            .environmentObject(UserSession.shared)
    }
}
