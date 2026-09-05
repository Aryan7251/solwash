import SwiftUI

// SolWash iOS Native Login View using SwiftUI
struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        ZStack {
            // Background Flat Slate
            Color(red: 248/255, green: 250/255, blue: 252/255)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                // Brand Badge
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(red: 30/255, green: 58/255, blue: 138/255))
                        .frame(width: 64, height: 64)
                    
                    Text("SOL")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                }
                
                // Header
                VStack(spacing: 6) {
                    Text("Welcome to SolWash")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(red: 15/255, green: 23/255, blue: 42/255))
                    
                    Text("Sign in to continue")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 100/255, green: 116/255, blue: 139/255))
                }
                
                // Form Card
                VStack(alignment: .leading, spacing: 18) {
                    // Error Notice
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.red)
                            .padding(.bottom, 4)
                    }
                    
                    // Email or Username Input
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email or Username")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Color(red: 51/255, green: 65/255, blue: 85/255))
                        
                        TextField("Enter your email or username", text: $viewModel.email)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .padding(12)
                            .background(Color(red: 248/255, green: 250/255, blue: 252/255))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(red: 203/255, green: 213/255, blue: 225/255), lineWidth: 1)
                            )
                    }
                    
                    // Password Input
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Password")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Color(red: 51/255, green: 65/255, blue: 85/255))
                        
                        SecureField("Enter your password", text: $viewModel.password)
                            .padding(12)
                            .background(Color(red: 248/255, green: 250/255, blue: 252/255))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(red: 203/255, green: 213/255, blue: 225/255), lineWidth: 1)
                            )
                    }
                    
                    // Forgot password link
                    HStack {
                        Spacer()
                        Button(action: {
                            // Handle forgot password
                        }) {
                            Text("Forgot Password?")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(red: 30/255, green: 58/255, blue: 138/255))
                        }
                    }
                    
                    // Submit Button
                    Button(action: {
                        viewModel.login()
                    }) {
                        HStack {
                            Spacer()
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Sign In")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            Spacer()
                        }
                        .frame(height: 48)
                        .background(Color(red: 30/255, green: 58/255, blue: 138/255))
                        .cornerRadius(10)
                    }
                    .disabled(viewModel.isLoading)
                }
                .padding(24)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
                .padding(.horizontal, 20)
                
                // Sign up prompt
                Button(action: {
                    // Navigate to sign up
                }) {
                    Text("Don't have an account? **Sign Up**")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 30/255, green: 58/255, blue: 138/255))
                }
                
                Spacer()
            }
        }
    }
}

// SwiftUI Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
