# Deehadi - Peer-to-Peer Car Rental Marketplace

<p align="center">
  <img src="https://img.shields.io/badge/Platform-iOS-blue.svg" alt="Platform">
  <img src="https://img.shields.io/badge/Swift-5.9-orange.svg" alt="Swift">
  <img src="https://img.shields.io/badge/SwiftUI-4.0-green.svg" alt="SwiftUI">
  <img src="https://img.shields.io/badge/iOS-16.0+-lightgrey.svg" alt="iOS">
</p>

## 📱 Project Overview

**Deehadi** is a modern peer-to-peer self-drive car rental marketplace built for iOS, designed specifically for the Indian market. The platform connects car owners who have underutilized vehicles with renters who need short-term access to cars, creating a trusted and secure rental ecosystem.

### 🎯 Key Value Proposition

- **For Car Owners**: Monetize idle vehicles with platform-managed insurance, deposits, and dispute handling
- **For Renters**: Access affordable, verified vehicles with transparent pricing and trip-based insurance included
- **Trust & Safety**: Comprehensive KYC verification, mandatory trip proofs, damage protection, and escrow payments

### 👥 Target Users

**Renters**
- Age 21+ with valid driving license
- Need short-term (1-7 days) self-drive cars
- Value safety, transparency, and affordable pricing
- Willing to provide security deposit and undergo verification

**Hosts/Owners**
- Individual car owners with vehicles idle most days
- Risk-averse and insurance-focused
- Expect platform to manage verification and disputes
- Want passive income from their assets

---

## 🛠 Tech Stack & Architecture

### Technologies Used

| Category | Technology |
|----------|------------|
| **UI Framework** | SwiftUI 4.0 |
| **Reactive Programming** | Combine + Swift Concurrency (async/await) |
| **Backend & Database** | Supabase (PostgreSQL) |
| **Authentication** | Supabase Auth (OTP-based) |
| **Storage** | Supabase Storage (media uploads) |
| **Architecture Pattern** | MVVM (Model-View-ViewModel) |
| **State Management** | ObservableObject + @Published |
| **Networking** | Supabase Swift SDK |
| **Image Handling** | SwiftUI AsyncImage + PhotosPicker |

### Architecture Pattern: MVVM

```
┌─────────────────────────────────────────────────────────────┐
│                         View Layer                           │
│  (SwiftUI Views - HomeView, CarDetailView, BookingView)     │
└────────────────────┬────────────────────────────────────────┘
                     │ @StateObject / @ObservedObject
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                      ViewModel Layer                         │
│   (ObservableObject - HomeViewModel, BookingViewModel)      │
│   • @Published state properties                             │
│   • Business logic & validation                             │
│   • Async data fetching with @MainActor                     │
└────────────────────┬────────────────────────────────────────┘
                     │ Service calls
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                      Service Layer                           │
│   • SupabaseManager (Singleton client)                      │
│   • AuthService (Sign in/up, OTP verification)              │
│   • UserSession (Global session + profile state)            │
└────────────────────┬────────────────────────────────────────┘
                     │ Network requests
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                    Supabase Backend                          │
│   • PostgreSQL database                                      │
│   • Row Level Security (RLS)                                │
│   • Storage buckets                                          │
│   • Real-time subscriptions (future)                        │
└─────────────────────────────────────────────────────────────┘
```

### High-Level App Flow

```
App Launch
    │
    ▼
SplashView (2.5s animation)
    │
    ▼
RootView (navigation coordinator)
    │
    ├─► Not Authenticated ──► WelcomeView ──► LoginView/SignupView
    │                                              │
    │                                              ▼
    │                                         Authenticated
    │                                              │
    ├─► Authenticated + No Profile ───────────────┤
    │                                              │
    │                                              ▼
    │                                     OnboardingFlowView
    │                                     (Role + Profile Setup)
    │                                              │
    ▼                                              ▼
Authenticated + Profile Complete ─────────► MainTabView
                                            │
                                            ├─► Home (Search & Browse)
                                            ├─► Bookings (My Reservations)
                                            ├─► Host (Dashboard & Management)
                                            └─► Profile (Settings & KYC)
```

---

## 📁 Project Structure

```
Deehadi/
├── DeehadiApp.swift              # App entry point (@main)
├── ContentView.swift             # Legacy root (unused)
│
├── App/
│   ├── Core/                     # Foundation & Navigation
│   │   ├── RootView.swift        # Root navigation coordinator
│   │   ├── SplashView.swift      # Animated splash screen
│   │   ├── MainTabView.swift     # Tab-based navigation (Home/Bookings/Host/Profile)
│   │   ├── AppTheme.swift        # Design system (colors, fonts, shadows)
│   │   ├── CommonUI.swift        # Reusable UI components (buttons, tags, cards)
│   │   ├── ImagePicker.swift     # Photo picker wrapper
│   │   └── Constants.swift       # Supabase config & app constants
│   │
│   ├── Services/                 # Business logic layer
│   │   ├── SupabaseManager.swift    # Singleton Supabase client
│   │   ├── AuthService.swift        # Sign in/up, OTP verification
│   │   └── UserSession.swift        # Global session state + profile management
│   │
│   ├── Models/                   # Data models
│   │   ├── Car.swift             # Car, PricingPlan, CarMedia models
│   │   └── Booking.swift         # Booking, BookingInsert models
│   │
│   ├── Auth/                     # Authentication screens
│   │   ├── LoginView.swift       # Email/password + OTP login
│   │   └── SignupView.swift      # New user registration
│   │
│   ├── Onboarding/               # First-time user setup
│   │   ├── WelcomeView.swift     # Welcome screen with value prop
│   │   └── OnboardingFlowView.swift  # Role selection + profile setup
│   │
│   └── Features/                 # Feature modules (MVVM per feature)
│       ├── Home/                 # Car discovery & search
│       │   ├── HomeView.swift
│       │   ├── HomeViewModel.swift
│       │   ├── FiltersView.swift
│       │   └── CarListCard.swift
│       │
│       ├── CarDetails/           # Car detail page
│       │   ├── CarDetailView.swift
│       │   └── CarDetailViewModel.swift
│       │
│       ├── Booking/              # Booking flow & management
│       │   ├── BookingSummaryView.swift
│       │   ├── BookingSuccessView.swift
│       │   ├── MyBookingsView.swift
│       │   ├── BookingViewModel.swift
│       │   └── MyBookingsViewModel.swift
│       │
│       └── Host/                 # Host/owner features
│           ├── HostDashboardView.swift
│           ├── HostBookingsView.swift
│           ├── AddCarView.swift
│           ├── KYCView.swift
│           └── HostViewModel.swift
│
├── Assets.xcassets/              # Images, colors, app icons
├── Supabase/                     # Database migrations (SQL files)
│   ├── 01_user_profiles.sql
│   ├── 05_cars.sql
│   ├── 10_bookings.sql
│   ├── 13_insurance_policies.sql
│   └── ... (23 migration files)
│
├── Context/                      # Product documentation
│   ├── prd.txt                   # Product Requirements Document
│   └── database.txt              # Database schema documentation
│
├── DeehadiTests/                 # Unit tests
└── DeehadiUITests/               # UI tests
```

### Directory Explanations

| Folder | Purpose |
|--------|---------|
| **Core** | App-wide navigation, theme, and reusable UI utilities |
| **Services** | Centralized business logic, API clients, and session management |
| **Models** | Codable Swift structs representing database entities |
| **Auth** | Authentication screens (login, signup, OTP verification) |
| **Onboarding** | First-run experience (role selection, profile setup) |
| **Features** | Self-contained feature modules organized by domain |
| **Supabase** | SQL migrations defining PostgreSQL schema |
| **Context** | Product documentation (PRD, database design) |

---

## ✨ Core Features

### 🔐 Authentication
- **OTP-based login** via Supabase Auth (phone/email)
- **Email/password signup** with verification
- **Session persistence** across app launches
- **Automatic session restoration** on app start
- **Secure sign-out** with state cleanup

### 👤 User Profiles & Onboarding
- **Role selection**: Renter, Owner, or Both
- **Profile creation**: Name, DOB, address, city, phone
- **Profile photo upload** to Supabase Storage
- **Onboarding completion tracking** (gates MainTab access)
- **Edit profile** from Profile tab

### 🚗 Car Listings & Search
- **Browse active cars** in selected city
- **Filters**: Price range, fuel type, transmission, seats
- **Search by brand/model**
- **Category filter**: All, Sedan, SUV, Electric, Luxury
- **Sort by**: Price (low to high, high to low), Rating
- **Real-time availability** checking

### 📋 Car Details View
- **Car info**: Brand, model, year, fuel, transmission, seats
- **Photo gallery** (swipeable carousel)
- **Owner profile** with ratings and trip count
- **Features list** (GPS, Bluetooth, sunroof, etc.)
- **Pricing breakdown**: Daily/weekly rates, security deposit
- **Insurance badge** (trip-based coverage included)
- **Book Now** button (renters) / **Edit Car** button (owners)

### 📅 Booking System
- **Date picker**: Start and end date/time selection
- **Price calculation**: Rental days × daily rate + deposit
- **Booking summary**: Car details, dates, total amount, deposit
- **Booking creation** with Supabase insert
- **Booking status tracking**: Pending → Active → Completed → Disputed
- **Success confirmation** screen with booking ID
- **KYC validation**: Blocks booking if KYC not approved

### 🏠 Host Dashboard
- **Overview metrics**: Total earnings, active bookings, total cars
- **Quick actions**: Add new car, view bookings, KYC status
- **My Cars list**: All cars owned with edit/delete options
- **Booking requests**: Accept/reject incoming reservations
- **Earnings history**: Trip-wise payout tracking

### ✅ KYC Verification
- **Document upload**: Driving license (front/back)
- **Camera/photo library selection**
- **Image upload to Supabase Storage** (`kyc-documents` bucket)
- **Status tracking**: Pending → Approved → Rejected
- **Admin approval workflow** (backend)
- **Blocks booking** until KYC approved

### 📸 Car Media Management
- **Multiple photo upload** (up to 5 images)
- **Photo positioning** (primary image first)
- **Delete/reorder media** (future enhancement)
- **Supabase Storage integration** (`car-images` bucket)
- **Automatic thumbnail generation** (future)

### 💰 Pricing Management
- **Flexible pricing plans**: Per-day, per-week rates
- **Security deposit configuration**
- **Late fee settings** (per-hour charges)
- **Dynamic pricing support** (future roadmap)

---

## 📊 Data Models

### UserProfile
```swift
struct UserProfile: Codable {
    let id: UUID                        // User ID (matches Supabase Auth)
    var full_name: String?              // Full name
    var dob: String?                    // Date of birth (YYYY-MM-DD)
    var profile_photo_url: String?      // Photo URL from Storage
    var phone_number: String?           // Phone number
    var is_owner: Bool?                 // Whether user is a host
    var address: String?                // Full address
    var city: String?                   // City
    var state: String?                  // State
    var pincode: String?                // Postal code
    var onboarding_completed: Bool?     // Gates MainTab access
}
```

### Car
```swift
struct Car: Codable, Identifiable {
    let id: UUID                        // Primary key
    let owner_id: UUID                  // Foreign key → user_profiles
    let registration_number: String     // Unique vehicle registration
    let brand: String                   // e.g., "Toyota"
    let model: String                   // e.g., "Innova"
    let year: Int                       // e.g., 2020
    let fuel_type: String               // Petrol/Diesel/Electric/CNG
    let transmission: String            // Manual/Automatic
    let seats: Int                      // 2-7
    let city: String                    // Pickup city
    let pickup_lat: Double?             // Latitude
    let pickup_lng: Double?             // Longitude
    let status: String                  // active/inactive/suspended
    let features: [String]?             // ["GPS", "Bluetooth"]
    let created_at: Date?
    
    // Relations (via Supabase joins)
    let pricing_plans: [PricingPlan]?
    let car_media: [CarMedia]?
    
    // Computed properties
    var fullName: String                // "Toyota Innova 2020"
    var pricePerDay: Int                // From pricing_plans
    var imageUrl: String                // First image URL
}
```

### PricingPlan
```swift
struct PricingPlan: Codable {
    let price_per_day: Double           // Daily rental rate (₹)
    let currency: String                // "INR"
}
```

### CarMedia
```swift
struct CarMedia: Codable {
    let url: String                     // Image/video URL
    let media_type: String              // "image" or "video"
    let position: Int                   // Display order (0-based)
}
```

### Booking
```swift
struct Booking: Codable, Identifiable {
    let id: UUID                        // Primary key
    let car_id: UUID                    // Foreign key → cars
    let renter_id: UUID                 // Foreign key → user_profiles
    let start_time: Date                // Trip start date/time
    let end_time: Date                  // Trip end date/time
    let status: String                  // pending/active/completed/cancelled/disputed
    let total_amount: Int               // Total rental amount (paise)
    let security_deposit: Int           // Refundable deposit (paise)
    let late_fee: Int?                  // Late return charges (paise)
    let created_at: Date?
    
    // Optional relations
    var car: Car?                       // Joined car details
    var renter: UserProfile?            // Joined renter details
}
```

### Key Relationships

```
user_profiles (1) ──┬──< (N) cars (owner_id)
                    │
                    └──< (N) bookings (renter_id)

cars (1) ──┬──< (N) car_media
           ├──< (N) pricing_plans
           ├──< (N) car_rules
           ├──< (N) car_availability
           └──< (N) bookings

bookings (1) ──┬──< (N) payments
               ├──< (N) insurance_policies
               ├──< (N) trip_proofs
               ├──< (N) damages
               └──< (N) disputes
```

---

## 🔧 Services Layer

### SupabaseManager (Singleton)
```swift
class SupabaseManager {
    static let shared = SupabaseManager()
    let client: SupabaseClient
    
    private init() {
        self.client = SupabaseClient(
            supabaseURL: Constants.Supabase.url,
            supabaseKey: Constants.Supabase.apiKey
        )
    }
}
```
- **Purpose**: Single source of truth for Supabase client
- **Usage**: `SupabaseManager.shared.client.from("cars")...`
- **Thread-safe**: Singleton ensures one instance

### AuthService
```swift
class AuthService {
    static func signUp(email: String, password: String, phone: String?) async throws -> Session
    static func signIn(email: String, password: String) async throws -> Session
    static func verifyOTP(phone: String, token: String) async throws -> Session
}
```
- **Sign Up**: Creates Supabase auth user + profile record
- **Sign In**: Email/password authentication
- **OTP Verification**: Phone-based OTP login
- **Error Handling**: Throws descriptive errors for UI display

### UserSession (Global State)
```swift
class UserSession: ObservableObject {
    static let shared = UserSession()
    
    @Published var session: Session?      // Supabase auth session
    @Published var profile: UserProfile?  // User profile data
    @Published var isLoading: Bool        // Session check in progress
    
    var isAuthenticated: Bool { session != nil }
    
    func checkSession() async             // Restore session on app start
    func fetchProfile() async             // Load profile from DB
    func signOut() async                  // Clear session + profile
}
```
- **Singleton Observable**: Shared across app via `@EnvironmentObject`
- **Session Restoration**: Auto-checks on app launch
- **Profile Sync**: Fetches profile after auth success
- **Reactive**: Views re-render on state changes

---

## 🎨 Feature Details

### Home / Discovery
**Files**: `HomeView.swift`, `HomeViewModel.swift`, `FiltersView.swift`, `CarListCard.swift`

**Functionality**:
- Fetches active cars from Supabase with joins (`car_media`, `pricing_plans`)
- Search bar filters by brand/model (local filtering)
- Category tabs: All, Sedan, SUV, Electric, Luxury
- Filters sheet: Price range, fuel type, transmission, seats
- Sort options: Price (low/high), Rating
- Card-based grid layout with AsyncImage loading
- Tap card → Navigate to CarDetailView

**ViewModel Pattern**:
```swift
@MainActor
class HomeViewModel: ObservableObject {
    @Published var cars: [Car] = []
    @Published var isLoading = false
    @Published var error: String?
    
    func fetchCars() async {
        // Query Supabase with filters
        // Update @Published properties on MainActor
    }
}
```

### Car Details
**Files**: `CarDetailView.swift`, `CarDetailViewModel.swift`

**Functionality**:
- Displays car info, photo carousel, owner profile
- Features list (GPS, Bluetooth, USB, etc.)
- Pricing breakdown with insurance badge
- "Book Now" button (renters) / "Edit Car" (owners)
- Fetches owner profile and ratings
- Navigation to BookingSummaryView with selected car

**Owner Info Section**:
- Profile photo, name, rating (⭐ 4.5)
- Total trips hosted
- Verified badge (if KYC approved)

### Booking Flow
**Files**: `BookingSummaryView.swift`, `BookingSuccessView.swift`, `BookingViewModel.swift`

**Flow**:
1. **BookingSummaryView**: Date picker + price calculation
2. **Validation**: KYC status check, date overlap check
3. **Booking Creation**: Insert into `bookings` table
4. **BookingSuccessView**: Confirmation with booking ID
5. **Navigate**: Back to Home or to MyBookingsView

**Validation Rules**:
- Start date must be in future
- End date must be after start date
- Renter must have approved KYC
- Car must be available for selected dates
- Security deposit must be paid upfront

### My Bookings
**Files**: `MyBookingsView.swift`, `MyBookingsViewModel.swift`

**Functionality**:
- Segmented control: Upcoming / Past
- Fetches bookings with joined car data
- Displays booking cards with status badges
- Status colors: Pending (yellow), Active (green), Completed (gray), Disputed (red)
- Tap card → Navigate to booking detail view (future)
- Pull to refresh

### Host Dashboard
**Files**: `HostDashboardView.swift`, `HostViewModel.swift`

**Sections**:
1. **Overview Cards**: Earnings, Active Bookings, Total Cars
2. **Quick Actions**: Add Car, View Bookings, KYC Status
3. **My Cars List**: Car cards with edit/delete
4. **Booking Requests**: Pending bookings to accept/reject

**Navigation**:
- "Add New Car" → AddCarView
- "View KYC Status" → KYCView
- "My Bookings" → HostBookingsView

### Host Bookings
**Files**: `HostBookingsView.swift`

**Functionality**:
- Lists all bookings for owner's cars
- Filters: Pending, Active, Completed
- Accept/Reject actions for pending bookings
- Shows renter info and car details
- Trip proof verification (future)

### Add/Edit Car
**Files**: `AddCarView.swift`, `HostViewModel.swift`

**Form Fields**:
- Registration number (unique)
- Brand, Model, Year
- Fuel type, Transmission, Seats
- City, Pickup location (lat/lng)
- Features (multi-select checkboxes)
- Pricing: Daily rate, security deposit
- Photos (up to 5 images)

**Workflow**:
1. Fill form with validation
2. Upload photos to Supabase Storage (`car-images` bucket)
3. Insert car record into `cars` table
4. Insert pricing plan into `pricing_plans` table
5. Insert media records into `car_media` table
6. Navigate back to HostDashboard

### KYC Verification
**Files**: `KYCView.swift`, `HostViewModel.swift`

**Workflow**:
1. Select document type (Driving License / Aadhaar / PAN)
2. Enter document number
3. Upload front image (camera/photo library)
4. Upload back image
5. Submit for admin approval
6. Track status: Pending → Approved / Rejected

**Storage**:
- Bucket: `kyc-documents`
- Path: `{user_id}/{document_type}_front.jpg`
- Record: `kyc_records` table with status field

### Onboarding Flow
**Files**: `OnboardingFlowView.swift`

**Steps**:
1. **Welcome Screen**: Value proposition + "Get Started" CTA
2. **Role Selection**: Renter / Owner / Both (radio buttons)
3. **Basic Info**: Full name, phone, DOB, city
4. **Profile Photo**: Upload optional photo
5. **Complete**: Mark `onboarding_completed = true` in profile
6. **Navigate**: To MainTabView (unlocks app)

**State Management**:
- Uses `@State` enum for current step
- Validates each step before advancing
- Persists to Supabase on completion

---

## 🚀 Setup & Installation

### Prerequisites
- **Xcode 15.0+** (supports Swift 5.9)
- **iOS 16.0+** deployment target
- **macOS Ventura 13.0+** (for Xcode 15)
- **Apple Developer Account** (for device testing)
- **Supabase Account** (for backend services)

### Supabase Configuration

1. **Create Supabase Project**
   - Visit [supabase.com](https://supabase.com) and create a project
   - Note down the `Project URL` and `anon public` API key

2. **Run Database Migrations**
   ```bash
   # Navigate to Supabase folder
   cd Supabase
   
   # Execute SQL files in order via Supabase SQL Editor
   # Or use Supabase CLI:
   supabase db push
   ```

3. **Create Storage Buckets**
   ```sql
   -- In Supabase SQL Editor or Dashboard > Storage
   INSERT INTO storage.buckets (id, name, public) VALUES
   ('profile-photos', 'profile-photos', true),
   ('car-images', 'car-images', true),
   ('kyc-documents', 'kyc-documents', false);
   ```

4. **Configure Row Level Security (RLS)**
   - Enable RLS on all tables via SQL migrations (already included)
   - Policies ensure users can only access their own data

5. **Update Constants.swift**
   ```swift
   struct Constants {
       struct Supabase {
           static let url = URL(string: "YOUR_PROJECT_URL")!
           static let apiKey = "YOUR_ANON_KEY"
       }
   }
   ```

### Environment Setup

1. **Clone Repository**
   ```bash
   git clone https://github.com/yourusername/deehadi-ios.git
   cd deehadi-ios
   ```

2. **Open in Xcode**
   ```bash
   open Deehadi.xcodeproj
   ```

3. **Install Dependencies**
   - Xcode will automatically resolve Swift Package Manager dependencies
   - Required: `supabase-swift` (v2.x)

4. **Configure Signing**
   - Select your development team in Xcode
   - Update bundle identifier if needed

5. **Run the App**
   - Select target device/simulator
   - Press `Cmd+R` to build and run

### Running on Device

1. Connect iPhone/iPad via USB
2. Trust the device in Xcode
3. Select device from scheme dropdown
4. Build and run (Xcode will install app)

---

## 🗄 Supabase Database Schema

### Core Tables

| Table | Description | Key Relationships |
|-------|-------------|-------------------|
| `user_profiles` | User details and preferences | `id` → auth.users.id |
| `kyc_records` | KYC verification documents | `user_id` → user_profiles.id |
| `bank_accounts` | Owner payout bank details | `user_id` → user_profiles.id |
| `cars` | Car listings and details | `owner_id` → user_profiles.id |
| `car_media` | Car photos and videos | `car_id` → cars.id |
| `car_rules` | Car rental rules and fees | `car_id` → cars.id |
| `car_availability` | Date-based availability | `car_id` → cars.id |
| `pricing_plans` | Daily/weekly pricing | `car_id` → cars.id |
| `bookings` | Rental reservations | `car_id` → cars.id, `renter_id` → user_profiles.id |
| `payments` | Payment transactions | `booking_id` → bookings.id |
| `payouts` | Owner payouts | `booking_id` → bookings.id, `owner_id` → user_profiles.id |
| `insurance_policies` | Trip insurance records | `booking_id` → bookings.id |
| `insurance_claims` | Insurance claim requests | `insurance_policy_id` → insurance_policies.id |
| `trip_proofs` | Pickup/return photos | `booking_id` → bookings.id |
| `trip_proof_media` | Proof images/videos | `trip_proof_id` → trip_proofs.id |
| `damages` | Damage reports | `booking_id` → bookings.id |
| `disputes` | Dispute cases | `booking_id` → bookings.id |
| `challans` | Traffic fines | `booking_id` → bookings.id |
| `ratings` | User ratings | `booking_id` → bookings.id |
| `support_tickets` | Support requests | `booking_id` → bookings.id, `user_id` → user_profiles.id |
| `admins` | Admin users | - |
| `audit_logs` | Audit trail | - |

### Entity Relationship Diagram (Text)

```
┌──────────────┐       ┌──────────────┐       ┌──────────────┐
│user_profiles │◄──────│     cars     │──────►│  car_media   │
│    (User)    │       │  (Vehicle)   │       │   (Photos)   │
└──────┬───────┘       └──────┬───────┘       └──────────────┘
       │                      │
       │                      ├──────►┌──────────────────┐
       │                      │       │ pricing_plans    │
       │                      │       └──────────────────┘
       │                      │
       │                      ├──────►┌──────────────────┐
       │                      │       │   car_rules      │
       │                      │       └──────────────────┘
       │                      │
       │                      ▼
       │               ┌──────────────┐
       └──────────────►│   bookings   │
                       │ (Reservation)│
                       └──────┬───────┘
                              │
                 ┌────────────┼────────────┐
                 ▼            ▼            ▼
          ┌──────────┐ ┌──────────┐ ┌──────────┐
          │ payments │ │insurance │ │trip_proofs│
          └──────────┘ │_policies │ └──────────┘
                       └──────────┘
```

### Design Principles

- **Primary Keys**: UUID (not integers) for security and distributed systems
- **Soft Deletes**: `deleted_at` column for audit trail
- **Money Storage**: All amounts in smallest unit (paise) as integers
- **Timestamps**: UTC timezone with `created_at`, `updated_at`
- **Foreign Keys**: Enforced with cascading rules
- **Indexes**: On frequently queried columns (city, status, dates)
- **RLS Policies**: User-level data isolation

---

## 📐 Development Guidelines

### Code Style Conventions

**SwiftUI Views**
```swift
// Use computed properties for view composition
struct CarDetailView: View {
    var body: some View {
        ScrollView {
            carHeader
            ownerInfo
            features
            pricingSection
        }
    }
    
    private var carHeader: some View {
        // Component code
    }
}
```

**Naming**
- Views: `PascalCase` ending with `View` (e.g., `CarDetailView`)
- ViewModels: `PascalCase` ending with `ViewModel` (e.g., `HomeViewModel`)
- Services: `PascalCase` with `Service` or `Manager` suffix
- Properties: `camelCase` (e.g., `isLoading`, `carsList`)
- Constants: `camelCase` in namespaced struct (e.g., `Constants.Supabase.url`)

**File Organization**
- One SwiftUI view per file
- Group related views in folders by feature (Home/, Booking/, etc.)
- Place ViewModels adjacent to their views
- Shared components in Core/CommonUI.swift

### MVVM Pattern Usage

**View Layer**
```swift
struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        // Only UI code, no business logic
    }
    
    func onAppear() {
        Task {
            await viewModel.fetchCars()
        }
    }
}
```

**ViewModel Layer**
```swift
@MainActor
class HomeViewModel: ObservableObject {
    @Published var cars: [Car] = []
    @Published var isLoading = false
    @Published var error: String?
    
    func fetchCars() async {
        isLoading = true
        // Business logic + service calls
        isLoading = false
    }
}
```

**Rules**:
- Views should never call services directly
- ViewModels handle all async operations
- Use `@MainActor` on ViewModel class to ensure UI updates on main thread
- Avoid `DispatchQueue.main.async` - use `await MainActor.run { }`

### Async/Await with MainActor

**Preferred Pattern**
```swift
@MainActor
class MyViewModel: ObservableObject {
    @Published var data: [Item] = []
    
    func fetchData() async {
        // Network call (off main thread)
        let items = try await SupabaseManager.shared.client
            .from("items")
            .select()
            .execute()
            .value
        
        // Automatic dispatch to main thread (no explicit code needed)
        self.data = items
    }
}
```

**Service Layer (No MainActor)**
```swift
class DataService {
    static func fetchItems() async throws -> [Item] {
        // Network call (off main thread)
        return try await SupabaseManager.shared.client...
    }
}
```

### Error Handling

**ViewModel Error Handling**
```swift
func fetchCars() async {
    isLoading = true
    error = nil
    
    do {
        let cars = try await SupabaseManager.shared.client
            .from("cars")
            .select()
            .execute()
            .value
        self.cars = cars
    } catch {
        self.error = error.localizedDescription
        print("Error fetching cars: \(error)")
    }
    
    isLoading = false
}
```

**View Error Display**
```swift
if let error = viewModel.error {
    Text("Error: \(error)")
        .foregroundColor(.red)
}
```

### Testing Approach

**Unit Tests** (`DeehadiTests/`)
- Test ViewModels in isolation
- Mock Supabase client responses
- Validate business logic (date calculations, pricing, etc.)

**UI Tests** (`DeehadiUITests/`)
- Test critical user flows (sign up, book car, add car)
- Use XCUITest framework
- Test on multiple device sizes

**Test Example**
```swift
class HomeViewModelTests: XCTestCase {
    func testFetchCarsSuccess() async throws {
        let viewModel = HomeViewModel()
        await viewModel.fetchCars()
        XCTAssertFalse(viewModel.cars.isEmpty)
        XCTAssertNil(viewModel.error)
    }
}
```

---

## 🚦 Current Status & Roadmap

### ✅ Completed Features (MVP)

**Authentication & Onboarding**
- ✅ Email/password signup and login
- ✅ OTP-based phone authentication
- ✅ User profile creation and editing
- ✅ Role selection (renter/owner/both)
- ✅ Onboarding flow with profile setup

**Renter Features**
- ✅ Browse active car listings
- ✅ Search and filter cars (price, type, transmission)
- ✅ Car detail page with photos and owner info
- ✅ Date-based booking with price calculation
- ✅ View my bookings (upcoming/past)
- ✅ KYC document upload (driving license)

**Host Features**
- ✅ Host dashboard with metrics
- ✅ Add new car with photos and pricing
- ✅ Manage car listings (view/edit/delete)
- ✅ View bookings for owned cars
- ✅ KYC verification workflow
- ✅ Upload car media to Supabase Storage

**Infrastructure**
- ✅ Supabase integration (auth, database, storage)
- ✅ MVVM architecture with async/await
- ✅ Global session management (UserSession)
- ✅ Design system (AppTheme, CommonUI)
- ✅ Navigation flow (Splash → Auth → Onboarding → MainTab)

### 🚧 In Progress

**Booking Enhancements**
- 🔄 Trip proof upload (pre-trip and post-trip photos)
- 🔄 Accept/reject booking flow (host side)
- 🔄 Booking cancellation with refund logic
- 🔄 Real-time booking status updates

**Payment Integration**
- 🔄 Razorpay/Stripe SDK integration
- 🔄 Payment gateway UI
- 🔄 Escrow and payout management
- 🔄 Security deposit collection

**Host Tools**
- 🔄 Earnings dashboard with analytics
- 🔄 Calendar view for car availability
- 🔄 Manual availability blocking

### 🔮 Future Enhancements (Roadmap)

**Phase 2 - Advanced Features**
- 📅 Insurance API integration (Acko)
- 📅 GPS tracking with geofencing
- 📅 Real-time chat between renter and owner
- 📅 Push notifications (booking updates, messages)
- 📅 Multi-city expansion with city selector
- 📅 Damage claim workflow with photo evidence
- 📅 Late fee auto-calculation and deduction
- 📅 Traffic challan forwarding system

**Phase 3 - Scale & Monetization**
- 📅 Dynamic pricing based on demand
- 📅 Subscription plans for frequent renters
- 📅 Loyalty programs and referral rewards
- 📅 In-app customer support chat
- 📅 Admin panel (web) for operations
- 📅 Analytics dashboard for owners
- 📅 Automated insurance claim processing
- 📅 AI-based risk scoring for renters

**Phase 4 - Platform Expansion**
- 📅 Cross-city drop-off support
- 📅 Luxury car category
- 📅 Long-term rentals (monthly subscriptions)
- 📅 Corporate accounts and bulk bookings
- 📅 Integration with third-party insurance providers
- 📅 WhatsApp Business API for notifications

---

## 🤝 Contributing

We welcome contributions from the community! Here's how you can help:

### How to Contribute

1. **Fork the Repository**
   ```bash
   git clone https://github.com/yourusername/deehadi-ios.git
   cd deehadi-ios
   ```

2. **Create a Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Your Changes**
   - Follow code style conventions (see Development Guidelines)
   - Add unit tests for new features
   - Update documentation if needed

4. **Commit Your Changes**
   ```bash
   git commit -m "feat: add booking cancellation flow"
   ```

5. **Push to Your Fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Open a Pull Request**
   - Use the PR template
   - Link related issues
   - Add screenshots for UI changes

### Branch Naming Conventions

| Prefix | Purpose | Example |
|--------|---------|---------|
| `feature/` | New feature | `feature/add-chat` |
| `bugfix/` | Bug fix | `bugfix/booking-crash` |
| `hotfix/` | Critical fix | `hotfix/payment-failure` |
| `refactor/` | Code refactoring | `refactor/viewmodel-cleanup` |
| `docs/` | Documentation | `docs/update-readme` |
| `test/` | Test additions | `test/add-booking-tests` |

### Commit Message Format

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

**Examples**:
```
feat(booking): add booking cancellation flow
fix(auth): resolve OTP verification timeout
docs(readme): update setup instructions
refactor(viewmodel): simplify HomeViewModel logic
```

### Pull Request Process

1. **Ensure PR passes CI checks** (linting, tests, build)
2. **Request review from maintainers**
3. **Address review feedback** with additional commits
4. **Squash and merge** once approved

### Code Review Checklist

- [ ] Code follows Swift style guide
- [ ] MVVM pattern correctly implemented
- [ ] No business logic in views
- [ ] Async operations use `@MainActor` correctly
- [ ] Error handling implemented
- [ ] Unit tests added/updated
- [ ] UI tested on iPhone and iPad
- [ ] No force unwraps (`!`) without justification
- [ ] Documentation comments for public APIs

---

## 📄 License

This project is licensed under the **MIT License**.

```
MIT License

Copyright (c) 2025 Deehadi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 📞 Support & Contact

### Questions or Issues?

- **GitHub Issues**: [Report bugs or request features](https://github.com/yourusername/deehadi-ios/issues)
- **Email**: support@deehadi.com
- **Discord**: [Join our developer community](https://discord.gg/deehadi)

### Documentation

- **Product Requirements**: `Context/prd.txt`
- **Database Schema**: `Context/database.txt`
- **API Documentation**: [Supabase Docs](https://supabase.com/docs)

---

## 🙏 Acknowledgments

- **SwiftUI**: Apple's declarative UI framework
- **Supabase**: Open-source Firebase alternative
- **Supabase Swift SDK**: Official Swift client library
- **SF Symbols**: Apple's icon library

---

## 📊 Project Stats

- **Lines of Code**: ~5,000+ Swift
- **Views**: 20+ SwiftUI screens
- **ViewModels**: 8 MVVM components
- **Database Tables**: 23 tables
- **Features**: 10+ major features
- **API Integration**: Supabase (Auth, Database, Storage)

---

<p align="center">
  Made with ❤️ in India | Empowering car owners and renters
</p>

<p align="center">
  <a href="https://github.com/yourusername/deehadi-ios">⭐ Star this repo</a> •
  <a href="https://github.com/yourusername/deehadi-ios/issues">🐛 Report Bug</a> •
  <a href="https://github.com/yourusername/deehadi-ios/issues">✨ Request Feature</a>
</p>
