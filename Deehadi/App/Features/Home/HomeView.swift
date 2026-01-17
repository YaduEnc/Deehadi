import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var session: UserSession
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                headerView
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Search & Filters
                        searchAndFiltersSection
                        
                        // Category Toggles
                        categoriesSection
                        
                        // Car List
                        if viewModel.isLoading {
                            ProgressView()
                                .padding(.top, 40)
                        } else {
                            carListSection
                        }
                    }
                    .padding(.vertical, 16)
                }
            }
            .background(AppTheme.Color.backgroundLight.ignoresSafeArea())
            .task {
                await viewModel.fetchCars()
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Good morning")
                    .font(AppTheme.Font.display(size: 24, weight: .bold))
                
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Text("Mumbai")
                            .font(AppTheme.Font.display(size: 14, weight: .medium))
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(AppTheme.Color.stone500)
                }
            }
            
            Spacer()
            
            // Profile Image
            ZStack(alignment: .topTrailing) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .foregroundColor(AppTheme.Color.stone300)
                
                Circle()
                    .fill(.green)
                    .frame(width: 10, height: 10)
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
    
    private var searchAndFiltersSection: some View {
        VStack(spacing: 16) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppTheme.Color.stone400)
                Text("Where do you want to drive?")
                    .font(AppTheme.Font.display(size: 16))
                    .foregroundColor(AppTheme.Color.stone400)
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(24)
            .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 24)
            
            // Date and Filter Buttons
            HStack(spacing: 12) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "calendar")
                        Text("Oct 12 - Oct 15")
                            .font(AppTheme.Font.display(size: 14, weight: .medium))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "slider.horizontal.3")
                        Text("Filters")
                            .font(AppTheme.Font.display(size: 14, weight: .medium))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
    
    private var categoriesSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(viewModel.categories, id: \.self) { category in
                    CategoryItem(
                        name: category,
                        icon: categoryIcon(for: category),
                        isSelected: viewModel.selectedCategory == category
                    ) {
                        viewModel.selectedCategory = category
                        Task {
                            await viewModel.fetchCars()
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
        }
    }
    
    private var carListSection: some View {
        VStack(spacing: 24) {
            if viewModel.cars.isEmpty && !viewModel.isLoading {
                VStack(spacing: 12) {
                    Image(systemName: "car.side.fill")
                        .font(.system(size: 60))
                        .foregroundColor(AppTheme.Color.stone200)
                    Text("No cars available in this area")
                        .font(AppTheme.Font.display(size: 16, weight: .medium))
                        .foregroundColor(AppTheme.Color.stone500)
                }
                .padding(.top, 40)
            } else {
                ForEach(viewModel.cars) { car in
                    NavigationLink(destination: CarDetailView(car: car)) {
                        CarCard(car: car)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(.horizontal, 24)
    }
    
    private func categoryIcon(for cat: String) -> String {
        switch cat {
        case "All": return "square.grid.2x2.fill"
        case "Sedan": return "car.fill"
        case "SUV": return "car.2.fill"
        case "Electric": return "bolt.car.fill"
        case "Luxury": return "crown.fill"
        default: return "car"
        }
    }
}

struct CategoryItem: View {
    let name: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isSelected ? AppTheme.Color.primary : Color.white)
                        .frame(width: 56, height: 56)
                        .shadow(color: Color.black.opacity(0.05), radius: 10)
                    
                    Image(systemName: icon)
                        .foregroundColor(isSelected ? .white : AppTheme.Color.stone400)
                        .font(.system(size: 20))
                }
                
                Text(name)
                    .font(AppTheme.Font.display(size: 12, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? AppTheme.Color.primary : AppTheme.Color.stone500)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CarCard: View {
    let car: Car
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image Section
            ZStack(alignment: .topLeading) {
                AsyncImage(url: URL(string: car.imageUrl)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.1)
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                
                // Tags
                HStack {
                    if car.isElectric {
                        TagLabel(text: "Electric", icon: "bolt.fill", color: Color(hex: "E3FCEF"), textColor: Color(hex: "006644"))
                    } else if car.hasInsurance {
                        TagLabel(text: "Insurance included", icon: nil, color: Color(hex: "FFF9DB"), textColor: Color(hex: "857200"))
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "heart")
                            .foregroundColor(.black)
                            .frame(width: 36, height: 36)
                            .background(BlurView(style: .systemThinMaterialLight).opacity(0.8))
                            .clipShape(Circle())
                    }
                }
                .padding(16)
            }
            
            // Content Section
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(car.fullName)
                        .font(AppTheme.Font.display(size: 20, weight: .bold))
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 12))
                        Text(car.rating > 0 ? String(format: "%.1f", car.rating) : "New")
                            .font(AppTheme.Font.display(size: 14, weight: .bold))
                        Text("(\(car.tripsCount) trips)")
                            .font(AppTheme.Font.display(size: 14))
                            .foregroundColor(AppTheme.Color.stone400)
                    }
                }
                
                Divider()
                    .padding(.vertical, 4)
                
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("TOTAL PRICE")
                            .font(AppTheme.Font.display(size: 10, weight: .bold))
                            .foregroundColor(AppTheme.Color.stone400)
                            .tracking(0.5)
                        
                        HStack(alignment: .bottom, spacing: 2) {
                            Text("₹\(car.pricePerDay)")
                                .font(AppTheme.Font.display(size: 20, weight: .bold))
                                .foregroundColor(AppTheme.Color.primary)
                            Text("/ day")
                                .font(AppTheme.Font.display(size: 14))
                                .foregroundColor(AppTheme.Color.stone400)
                                .padding(.bottom, 2)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Book Now")
                            .font(AppTheme.Font.display(size: 14, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(AppTheme.Color.stone100)
                            .cornerRadius(16)
                    }
                }
            }
            .padding(20)
        }
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.04), radius: 15, x: 0, y: 10)
    }
}

struct TagLabel: View {
    let text: String
    let icon: String?
    let color: Color
    let textColor: Color
    
    var body: some View {
        HStack(spacing: 4) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 10))
            }
            Text(text)
                .font(AppTheme.Font.display(size: 10, weight: .bold))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(color)
        .foregroundColor(textColor)
        .clipShape(Capsule())
    }
}

#Preview {
    HomeView()
        .environmentObject(UserSession.shared)
}
