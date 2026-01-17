import SwiftUI

struct KYCView: View {
    @StateObject private var viewModel = HostViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State private var showingImagePicker = false
    @State private var selectedSide: String? // "front" or "back"
    
    var body: some View {
        ZStack {
            AppTheme.Color.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(AppTheme.Font.display(size: 16, weight: .medium))
                        .foregroundColor(AppTheme.Color.primary)
                    }
                    Spacer()
                }
                .padding()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Verify your identity")
                            .font(AppTheme.Font.display(size: 28, weight: .bold))
                            .padding(.bottom, 4)
                        
                        Text("This helps keep our community safe and ensures a secure experience for everyone.")
                            .font(AppTheme.Font.display(size: 16))
                            .foregroundColor(AppTheme.Color.stone500)
                            .lineSpacing(4)
                        
                        // Upload Cards
                        VStack(spacing: 16) {
                            uploadCard(title: "Driving license (front)", side: "front", image: viewModel.frontLicenseImage)
                            uploadCard(title: "Driving license (back)", side: "back", image: viewModel.backLicenseImage)
                        }
                        .padding(.vertical, 12)
                        
                        // Why Verify Section
                        VStack(alignment: .leading, spacing: 20) {
                            Text("WHY WE VERIFY")
                                .font(AppTheme.Font.display(size: 12, weight: .bold))
                                .foregroundColor(AppTheme.Color.stone400)
                                .tracking(1)
                            
                            featureRow(icon: "checkmark.shield.fill", title: "Trust & Safety", desc: "Confirming your identity helps prevent fraud and keeps the community secure.")
                            featureRow(icon: "shield.fill", title: "Insurance Requirements", desc: "Verified drivers are necessary for comprehensive insurance coverage.")
                            featureRow(icon: "lock.fill", title: "Data Protection", desc: "Your documents are encrypted and only used for verification purposes.")
                        }
                        .padding(.top, 16)
                    }
                    .padding(24)
                }
                
                // Submit Button
                VStack {
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.bottom, 8)
                    }
                    
                    Button(action: {
                        Task {
                            await viewModel.submitKYC()
                        }
                    }) {
                        HStack {
                            if viewModel.isSubmittingKYC {
                                ProgressView().tint(.white)
                            } else {
                                Text("Submit for verification")
                            }
                        }
                        .font(AppTheme.Font.display(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color(hex: "1F1F1F"))
                        .cornerRadius(12)
                    }
                    .disabled(viewModel.frontLicenseImage == nil || viewModel.backLicenseImage == nil || viewModel.isSubmittingKYC)
                    .opacity((viewModel.frontLicenseImage == nil || viewModel.backLicenseImage == nil) ? 0.5 : 1)
                }
                .padding(24)
                .background(Color.white)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: Binding(
                get: { selectedSide == "front" ? viewModel.frontLicenseImage : viewModel.backLicenseImage },
                set: { 
                    if selectedSide == "front" { viewModel.frontLicenseImage = $0 }
                    else { viewModel.backLicenseImage = $0 }
                }
            ))
        }
    }
    
    private func uploadCard(title: String, side: String, image: UIImage?) -> some View {
        Button(action: {
            selectedSide = side
            showingImagePicker = true
        }) {
            VStack(spacing: 12) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 140)
                        .frame(maxWidth: .infinity)
                        .clipped()
                } else {
                    Circle()
                        .fill(AppTheme.Color.stone100)
                        .frame(width: 56, height: 56)
                        .overlay(
                            Image(systemName: "camera.fill")
                                .font(.system(size: 24))
                                .foregroundColor(AppTheme.Color.stone400)
                        )
                    
                    VStack(spacing: 4) {
                        Text(title)
                            .font(AppTheme.Font.display(size: 16, weight: .bold))
                            .foregroundColor(.black)
                        Text("TAP TO UPLOAD OR TAKE PHOTO")
                            .font(AppTheme.Font.display(size: 10, weight: .bold))
                            .foregroundColor(AppTheme.Color.stone400)
                    }
                }
            }
            .frame(height: 180)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppTheme.Color.stone100, lineWidth: 1)
            )
        }
    }
    
    private func featureRow(icon: String, title: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20)) // Fixed size for icon
                .foregroundColor(AppTheme.Color.stone400)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppTheme.Font.display(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.Color.textPrimary)
                Text(desc)
                    .font(AppTheme.Font.display(size: 14))
                    .foregroundColor(AppTheme.Color.stone500)
                    .lineLimit(3)
            }
        }
    }
}

#Preview {
    KYCView()
}
