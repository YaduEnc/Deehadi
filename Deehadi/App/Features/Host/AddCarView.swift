import SwiftUI

struct AddCarView: View {
    @StateObject private var viewModel = HostViewModel() // In real app, pass environment object from Dashboard
    @Environment(\.dismiss) var dismiss
    
    @State private var showingImagePicker = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                AppTheme.Color.backgroundLight.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 32) {
                        
                        // 1. Photos
                        VStack(alignment: .leading, spacing: 16) {
                            Text("PHOTOS")
                                .font(AppTheme.Font.display(size: 12, weight: .bold))
                                .foregroundColor(AppTheme.Color.stone400)
                                .tracking(1)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    Button(action: { showingImagePicker = true }) {
                                        VStack(spacing: 8) {
                                            Image(systemName: "camera.fill")
                                                .font(.system(size: 24))
                                            Text("COVER")
                                                .font(AppTheme.Font.display(size: 10, weight: .bold))
                                        }
                                        .foregroundColor(AppTheme.Color.stone400)
                                        .frame(width: 120, height: 160)
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(AppTheme.Color.stone200, style: StrokeStyle(lineWidth: 1, dash: [4]))
                                        )
                                    }
                                    
                                    // Display selected images
                                    ForEach(viewModel.carImages, id: \.self) { img in
                                        Image(uiImage: img)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 120, height: 160)
                                            .cornerRadius(12)
                                            .clipped()
                                    }
                                }
                            }
                        }
                        
                        // 2. Basic Info
                        VStack(alignment: .leading, spacing: 16) {
                            Text("BASIC INFO")
                                .font(AppTheme.Font.display(size: 12, weight: .bold))
                                .foregroundColor(AppTheme.Color.stone400)
                                .tracking(1)
                            
                            InputField(title: "BRAND", placeholder: "Select brand", text: $viewModel.brand)
                            InputField(title: "MODEL", placeholder: "Select model", text: $viewModel.model)
                            InputField(title: "YEAR", placeholder: "e.g. 2023", text: $viewModel.year)
                            InputField(title: "LICENSE PLATE", placeholder: "e.g. MH 02 AB 1234", text: $viewModel.licensePlate)
                        }
                        
                        // 3. Technical
                        VStack(alignment: .leading, spacing: 16) {
                            Text("TECHNICAL")
                                .font(AppTheme.Font.display(size: 12, weight: .bold))
                                .foregroundColor(AppTheme.Color.stone400)
                                .tracking(1)
                            
                            Text("FUEL TYPE")
                                .font(AppTheme.Font.display(size: 10, weight: .bold))
                                .foregroundColor(AppTheme.Color.stone400)
                            
                            HStack(spacing: 12) {
                                OptionButton(title: "Petrol", isSelected: viewModel.fuelType == "Petrol") { viewModel.fuelType = "Petrol" }
                                OptionButton(title: "Diesel", isSelected: viewModel.fuelType == "Diesel") { viewModel.fuelType = "Diesel" }
                                OptionButton(title: "Electric", isSelected: viewModel.fuelType == "Electric") { viewModel.fuelType = "Electric" }
                            }
                            
                            Text("TRANSMISSION")
                                .font(AppTheme.Font.display(size: 10, weight: .bold))
                                .foregroundColor(AppTheme.Color.stone400)
                                .padding(.top, 8)
                            
                            HStack(spacing: 12) {
                                OptionButton(title: "Manual", isSelected: viewModel.transmission == "Manual") { viewModel.transmission = "Manual" }
                                OptionButton(title: "Automatic", isSelected: viewModel.transmission == "Automatic") { viewModel.transmission = "Automatic" }
                            }
                        }
                        
                        // 4. Pricing & Rules
                        VStack(alignment: .leading, spacing: 16) {
                            Text("PRICING & RULES")
                                .font(AppTheme.Font.display(size: 12, weight: .bold))
                                .foregroundColor(AppTheme.Color.stone400)
                                .tracking(1)
                            
                            InputField(title: "PRICE PER DAY", placeholder: "$ 0.00", text: $viewModel.pricePerDay)
                            InputField(title: "CITY", placeholder: "e.g. Mumbai", text: $viewModel.city)
                            
                            ToggleRow(icon: "smoke.fill", title: "No smoking", isOn: .constant(true))
                            ToggleRow(icon: "building.2.fill", title: "City use only", isOn: .constant(false))
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(24)
                }
                
                // Save Button
                VStack {
                    if let error = viewModel.errorMessage {
                        Text(error).foregroundColor(.red).font(.caption).padding(.bottom, 4)
                    }
                    
                    Button(action: {
                        Task {
                            if await viewModel.addNewCar() {
                                dismiss()
                            }
                        }
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView().tint(.white)
                            } else {
                                Text("Save & continue")
                            }
                        }
                        .font(AppTheme.Font.display(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color(hex: "2D2D2D"))
                        .cornerRadius(12)
                    }
                }
                .padding(24)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, y: -5)
            }
            .navigationTitle("Add your car")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left") // Simple back button
                            .foregroundColor(AppTheme.Color.primary)
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: Binding(
                    get: { nil }, // Placeholder logic for now
                    set: { if let img = $0 { viewModel.carImages.append(img) } }
                ))
            }
        }
    }
}

// Helper Components
struct InputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppTheme.Font.display(size: 10, weight: .bold))
                .foregroundColor(AppTheme.Color.stone400)
            
            TextField(placeholder, text: $text)
                .padding()
                .background(AppTheme.Color.stone100)
                .cornerRadius(12)
        }
    }
}

struct OptionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.Font.display(size: 14, weight: .bold))
                .foregroundColor(isSelected ? .white : AppTheme.Color.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? Color.black : Color.white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.black : AppTheme.Color.stone200, lineWidth: 1)
                )
        }
    }
}

struct ToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(AppTheme.Color.stone400)
            Text(title)
                .font(AppTheme.Font.display(size: 14, weight: .bold))
                .foregroundColor(AppTheme.Color.textPrimary)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
    }
}

#Preview {
    AddCarView()
}
