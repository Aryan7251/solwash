# SolWash Mobile App Native Login Forms

Native mobile login screens tailored for Android (**Kotlin**) and iOS (**Swift / SwiftUI**), configured to talk to the SolWash Node.js Backend API (`http://localhost:5000/api/auth/login`).

---

## 📱 Android (Kotlin)
Directory: `frontend/android_kotlin/`

### Included Implementations:
1. **Jetpack Compose (`LoginScreenCompose.kt`)**:
   - Modern, declarative UI with Material 3.
   - Coroutine-based network calls with loading states & error banners.
   - SolWash Deep Blue theme (`#1E3A8A`) and rounded flat card styling.
2. **Traditional XML & ViewBinding (`LoginActivity.kt` + `activity_login.xml`)**:
   - Standard Android Views using `TextInputLayout` & `MaterialButton`.
   - `SharedPreferences` session token storage.

### Connecting to Backend:
- Android Emulator connects via `http://10.0.2.2:5000/api`.
- Physical devices connect via your machine's LAN IP (e.g. `http://192.168.x.x:5000/api`).

---

## 🍎 iOS (Swift / SwiftUI)
Directory: `frontend/ios_swift/`

### Included Implementations:
1. **SwiftUI View (`LoginView.swift`)**:
   - Modern declarative UI with `SecureField`, animated loading indicator, and SolWash brand badge.
   - Fully reactive with MVVM pattern.
2. **ViewModel (`LoginViewModel.swift`)**:
   - `@Published` properties (`email`, `password`, `isLoading`, `errorMessage`, `isAuthenticated`).
   - Native `URLSession` asynchronous request to `POST /api/auth/login`.
   - Automatic token storage in `UserDefaults`.

### Connecting to Backend:
- iOS Simulator connects directly via `http://127.0.0.1:5000/api`.
- Physical devices connect via LAN IP.
