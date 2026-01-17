import SwiftUI

struct AppTheme {
    struct Color {
        static let primary = SwiftUI.Color(hex: "2D7A7B")
        static let backgroundLight = SwiftUI.Color(hex: "FAFAF9")
        static let backgroundDark = SwiftUI.Color(hex: "1A1A1A")
        static let stone50 = SwiftUI.Color(hex: "fafaf9")
        static let stone100 = SwiftUI.Color(hex: "f5f5f4")
        static let stone200 = SwiftUI.Color(hex: "e7e5e4")
        static let stone300 = SwiftUI.Color(hex: "d6d3d1")
        static let stone400 = SwiftUI.Color(hex: "a8a29e")
        static let stone500 = SwiftUI.Color(hex: "78716c")
        static let stone600 = SwiftUI.Color(hex: "57534e")
        static let stone700 = SwiftUI.Color(hex: "44403c")
        static let stone800 = SwiftUI.Color(hex: "292524")
        static let stone900 = SwiftUI.Color(hex: "1c1917")
    }
    
    struct Font {
        static func display(size: CGFloat, weight: SwiftUI.Font.Weight = .regular) -> SwiftUI.Font {
            // "Manrope" is requested. If not available on system, SF Pro is the fallback.
            return .system(size: size, weight: weight, design: .rounded)
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
