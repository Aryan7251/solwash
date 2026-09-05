import SwiftUI

// SolWash / Solar Care Complete SwiftUI Screens inspired by screenshots

// MARK: - 1. Home Screen (Photo 552)
struct SolarHomeScreen: View {
    @Binding var selectedTab: Int
    @State private var showBookingModal = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Top Greeting & Avatar
                HStack {
                    Text("Hello, User")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(red: 15/255, green: 23/255, blue: 42/255))
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "bell")
                            .font(.system(size: 19))
                            .foregroundColor(Color(red: 51/255, green: 65/255, blue: 85/255))
                    }
                    
                    ZStack {
                        Circle()
                            .fill(Color(red: 241/255, green: 245/255, blue: 249/255))
                            .frame(width: 38, height: 38)
                            .overlay(Circle().stroke(Color(red: 226/255, green: 232/255, blue: 240/255), lineWidth: 1))
                        
                        Image(systemName: "person.fill")
                            .foregroundColor(Color(red: 148/255, green: 163/255, blue: 184/255))
                    }
                }
                .padding(.top, 8)
                
                // Navy Blue Hero Card with Golden Button
                VStack(alignment: .leading, spacing: 14) {
                    Text("Welcome to Solar Care!")
                        .font(.system(size: 19, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Get started by booking your first\ncleaning")
                        .font(.system(size: 13))
                        .foregroundColor(Color(red: 203/255, green: 213/255, blue: 225/255))
                        .lineSpacing(4)
                    
                    Button(action: { selectedTab = 1 }) {
                        Text("Book Cleaning")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(red: 15/255, green: 23/255, blue: 42/255))
                            .padding(.horizontal, 22)
                            .padding(.vertical, 11)
                            .background(Color(red: 245/255, green: 166/255, blue: 35/255))
                            .cornerRadius(8)
                    }
                }
                .padding(22)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(red: 17/255, green: 29/255, blue: 56/255))
                .cornerRadius(16)
                
                Text("Book One-Time Service")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(red: 15/255, green: 23/255, blue: 42/255))
                
                // Deal Card (₹150 50% OFF)
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("₹150")
                                .font(.system(size: 26, weight: .heavy))
                                .foregroundColor(Color(red: 15/255, green: 23/255, blue: 42/255))
                            Text("50% OFF")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(red: 245/255, green: 166/255, blue: 35/255))
                        }
                        
                        Spacer()
                        
                        Button(action: { showBookingModal = true }) {
                            Text("Book Now")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Color(red: 17/255, green: 29/255, blue: 56/255))
                                .padding(.horizontal, 18)
                                .padding(.vertical, 8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(red: 17/255, green: 29/255, blue: 56/255), lineWidth: 1.5)
                                )
                        }
                    }
                    
                    Text("Standard Cleanings")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(red: 15/255, green: 23/255, blue: 42/255))
                    
                    HStack(spacing: 12) {
                        Label("Cleaning", systemImage: "checkmark.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color(red: 100/255, green: 116/255, blue: 139/255))
                        Label("Standard Cleaning", systemImage: "checkmark.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color(red: 100/255, green: 116/255, blue: 139/255))
                    }
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(red: 254/255, green: 240/255, blue: 138/255), lineWidth: 1.5)
                )
                
                // Explore more services
                Button(action: { selectedTab = 1 }) {
                    Text("Explore more services")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(red: 100/255, green: 116/255, blue: 139/255))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 226/255, green: 232/255, blue: 240/255), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 90)
        }
    }
}

// MARK: - 2. My Bookings Screen (Photo 551)
struct SolarBookingsScreen: View {
    @State private var search = ""
    @State private var filter = "All"
    let filterOptions = ["All", "Pending", "Accepted", "In Progress"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("My Bookings")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color(red: 15/255, green: 23/255, blue: 42/255))
                .padding(.top, 8)
            
            // Search field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color(red: 100/255, green: 116/255, blue: 139/255))
                TextField("Search here...", text: $search)
            }
            .padding(12)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(red: 226/255, green: 232/255, blue: 240/255), lineWidth: 1))
            
            // Pills
            HStack(spacing: 8) {
                ForEach(filterOptions, id: \.self) { opt in
                    Button(action: { filter = opt }) {
                        Text(opt)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(filter == opt ? .white : Color(red: 100/255, green: 116/255, blue: 139/255))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(filter == opt ? Color(red: 17/255, green: 29/255, blue: 56/255) : Color(red: 241/255, green: 245/255, blue: 249/255))
                            .cornerRadius(8)
                    }
                }
            }
            
            // Empty view (Photo 551)
            Spacer()
            VStack(spacing: 12) {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 40))
                    .foregroundColor(Color(red: 148/255, green: 163/255, blue: 184/255))
                    .padding(.bottom, 6)
                
                Text("No Bookings Available")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(red: 15/255, green: 23/255, blue: 42/255))
                
                Text("We couldn't find any booking at the moment.\nPlease check back later.")
                    .font(.system(size: 13))
                    .foregroundColor(Color(red: 100/255, green: 116/255, blue: 139/255))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 90)
    }
}

// MARK: - 3. Profile & App Settings Screen (Photo 550)
struct SolarProfileScreen: View {
    @State private var showLoginSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Profile")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color(red: 15/255, green: 23/255, blue: 42/255))
                .padding(.top, 8)
            
            Text("App Settings")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(red: 100/255, green: 116/255, blue: 139/255))
            
            // Settings Box
            VStack(spacing: 0) {
                SettingsRow(title: "Help & Support", iconName: "headphones")
                Divider()
                SettingsRow(title: "Terms & Conditions", iconName: "doc.text")
                Divider()
                SettingsRow(title: "Privacy Policy", iconName: "lock")
            }
            .background(Color.white)
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(red: 226/255, green: 232/255, blue: 240/255), lineWidth: 1))
            
            Spacer().frame(height: 20)
            
            Button(action: { showLoginSheet = true }) {
                Text("Login")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(red: 17/255, green: 29/255, blue: 56/255))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(red: 17/255, green: 29/255, blue: 56/255), lineWidth: 1.5)
                    )
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 90)
    }
}

struct SettingsRow: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(Color(red: 51/255, green: 65/255, blue: 85/255))
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(red: 30/255, green: 41/255, blue: 59/255))
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 13))
                .foregroundColor(Color(red: 148/255, green: 163/255, blue: 184/255))
        }
        .padding(16)
    }
}
