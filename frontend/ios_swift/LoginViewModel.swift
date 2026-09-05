import Foundation
import Combine

// Observable ViewModel managing API communication and authentication state
class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var isAuthenticated = false
    @Published var loggedInUserName: String? = nil
    
    // For iOS Simulator localhost is 127.0.0.1; for physical device use your computer's IP
    private let baseURL = "http://127.0.0.1:5000/api"
    
    func login() {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Email or Username is required."
            return
        }
        
        guard !password.isEmpty else {
            errorMessage = "Password is required."
            return
        }
        
        errorMessage = nil
        isLoading = true
        
        guard let url = URL(string: "\(baseURL)/auth/login") else {
            errorMessage = "Invalid server URL."
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let body: [String: Any] = [
            "email": email.trimmingCharacters(in: .whitespaces),
            "password": password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            errorMessage = "Failed to serialize login payload."
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "Empty response from server."
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        let success = json["success"] as? Bool ?? false
                        
                        if success, let dataDict = json["data"] as? [String: Any] {
                            let token = dataDict["token"] as? String ?? ""
                            let userDict = dataDict["user"] as? [String: Any] ?? [:]
                            let name = userDict["name"] as? String ?? "Customer"
                            
                            // Save Auth Token securely
                            UserDefaults.standard.set(token, forKey: "solwash_token")
                            
                            self?.loggedInUserName = name
                            self?.isAuthenticated = true
                        } else {
                            let msg = json["message"] as? String ?? "Invalid login credentials."
                            self?.errorMessage = msg
                        }
                    }
                } catch {
                    self?.errorMessage = "Invalid response format."
                }
            }
        }.resume()
    }
}
