import SwiftUI

struct FiltersView: View {
    @Environment(\.dismiss) var dismiss
    @State private var location = "San Francisco, CA"
    @State private var priceRange: ClosedRange<Double> = 80...240
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    // Location Section
                    locationSection
                    
                    // Dates Section
                    datesSection
                    
                    // Calendar Placeholder
                    calendarSection
                    
                    // Price Range
                    priceRangeSection
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
            }
            
            // Bottom Action
            bottomActionView
        }
        .background(AppTheme.Color.backgroundLight.ignoresSafeArea())
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text("Filters")
                .font(AppTheme.Font.display(size: 18, weight: .bold))
            
            Spacer()
            
            Button("Clear all") {
                // Clear filters
            }
            .font(AppTheme.Font.display(size: 14, weight: .bold))
            .foregroundColor(AppTheme.Color.stone400)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Color.white)
    }
    
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("LOCATION")
                .font(AppTheme.Font.display(size: 12, weight: .bold))
                .foregroundColor(AppTheme.Color.stone400)
                .tracking(0.5)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppTheme.Color.stone400)
                TextField("Search location", text: $location)
                    .font(AppTheme.Font.display(size: 16, weight: .medium))
                Spacer()
                Image(systemName: "location.fill")
                    .foregroundColor(AppTheme.Color.primary)
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
    
    private var datesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("DATES")
                    .font(AppTheme.Font.display(size: 12, weight: .bold))
                    .foregroundColor(AppTheme.Color.stone400)
                    .tracking(0.5)
                Spacer()
                Text("4 Days")
                    .font(AppTheme.Font.display(size: 10, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: "F8F9FA"))
                    .cornerRadius(8)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Pick-up")
                        .font(AppTheme.Font.display(size: 12))
                        .foregroundColor(AppTheme.Color.stone400)
                    Text("Oct 12")
                        .font(AppTheme.Font.display(size: 16, weight: .bold))
                    Text("10:00 AM")
                        .font(AppTheme.Font.display(size: 12))
                        .foregroundColor(AppTheme.Color.stone400)
                }
                
                Spacer()
                Image(systemName: "arrow.right")
                    .foregroundColor(AppTheme.Color.stone300)
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Drop-off")
                        .font(AppTheme.Font.display(size: 12))
                        .foregroundColor(AppTheme.Color.stone400)
                    Text("Oct 16")
                        .font(AppTheme.Font.display(size: 16, weight: .bold))
                    Text("10:00 AM")
                        .font(AppTheme.Font.display(size: 12))
                        .foregroundColor(AppTheme.Color.stone400)
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black.opacity(0.05), lineWidth: 1)
            )
        }
    }
    
    private var calendarSection: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                Spacer()
                Text("October 2023")
                    .font(AppTheme.Font.display(size: 16, weight: .bold))
                Spacer()
                Button(action: {}) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.black)
                }
            }
            
            // Days of Week
            let days = ["SU", "MO", "TU", "WE", "TH", "FR", "SA"]
            HStack {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(AppTheme.Font.display(size: 10, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(AppTheme.Color.stone400)
                }
            }
            
            // Dummy Calendar Grid
            VStack(spacing: 12) {
                HStack {
                    ForEach(0..<7) { i in
                        Text(i < 3 ? "" : "\(i-2)")
                            .font(AppTheme.Font.display(size: 14, weight: .medium))
                            .frame(maxWidth: .infinity)
                    }
                }
                HStack {
                    ForEach(5..<12) { i in
                        Text("\(i)")
                            .font(AppTheme.Font.display(size: 14, weight: .medium))
                            .frame(maxWidth: .infinity)
                    }
                }
                HStack {
                    ForEach(12..<19) { i in
                        ZStack {
                            if i == 12 || i == 16 {
                                Circle().fill(AppTheme.Color.stone700).frame(width: 36, height: 36)
                            } else if i > 12 && i < 16 {
                                Rectangle().fill(AppTheme.Color.stone100).frame(height: 36)
                            }
                            Text("\(i)")
                                .font(AppTheme.Font.display(size: 14, weight: .bold))
                                .foregroundColor(i == 12 || i == 16 ? .white : .black)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                HStack {
                    ForEach(19..<22) { i in
                        Text("\(i)")
                            .font(AppTheme.Font.display(size: 14, weight: .medium))
                            .frame(maxWidth: .infinity)
                    }
                    Spacer().frame(maxWidth: .infinity)
                    Spacer().frame(maxWidth: .infinity)
                    Spacer().frame(maxWidth: .infinity)
                    Spacer().frame(maxWidth: .infinity)
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.02), radius: 10, x: 0, y: 5)
    }
    
    private var priceRangeSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("PRICE RANGE")
                    .font(AppTheme.Font.display(size: 12, weight: .bold))
                    .foregroundColor(AppTheme.Color.stone400)
                    .tracking(0.5)
                Spacer()
                Text("$\(Int(priceRange.lowerBound)) - $\(Int(priceRange.upperBound))+")
                    .font(AppTheme.Font.display(size: 14, weight: .bold))
                Text("/ day")
                    .font(AppTheme.Font.display(size: 12))
                    .foregroundColor(AppTheme.Color.stone400)
            }
            
            // Slider Placeholder
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(AppTheme.Color.stone100)
                    .frame(height: 4)
                
                Rectangle()
                    .fill(AppTheme.Color.stone300)
                    .frame(width: 200, height: 4)
                    .padding(.leading, 50)
                
                HStack(spacing: 80) {
                    Circle().fill(.white).frame(width: 24, height: 24).shadow(radius: 2)
                    Circle().fill(AppTheme.Color.stone300).frame(width: 24, height: 24).shadow(radius: 2)
                }
                .padding(.leading, 40)
            }
            .padding(.horizontal, 10)
        }
    }
    
    private var bottomActionView: some View {
        VStack {
            Button(action: { dismiss() }) {
                HStack {
                    Text("Show 124 cars")
                    Image(systemName: "arrow.right")
                }
                .font(AppTheme.Font.display(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(AppTheme.Color.stone700)
                .cornerRadius(20)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 24)
        }
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: -5)
    }
}

#Preview {
    FiltersView()
}
