# SolWash - Project Summary & Quick Reference

> Saved Conversation Reference: Whenever you return and type **`solwash`**, this document serves as the complete snapshot of all progress, deployments, credentials, and download links.

---

## 1. Live Cloud Deployments (Render)
- **Backend API:** [https://solwash-backend-8b5e.onrender.com](https://solwash-backend-8b5e.onrender.com)
  - Health Check: `https://solwash-backend-8b5e.onrender.com/api/health`
- **Admin Panel:** [https://solwash-admin-8b5e.onrender.com](https://solwash-admin-8b5e.onrender.com)
  - Default Admin Username: `admin` (or `admin@solwash.com`)
  - Default Admin Password: `admin` (or `Admin@123456`)

---

## 2. GitHub Repository
- **Repository URL:** [https://github.com/Aryan7251/solwash](https://github.com/Aryan7251/solwash)
- **Branch:** `main`
- **CI/CD:** Automated GitHub Actions APK build workflow (`.github/workflows/build-apk.yml`)

---

## 3. Android App (APK)
- **Direct Phone Download:** [Download SolWash.apk (v1.0.0)](https://github.com/Aryan7251/solwash/releases/download/v1.0.0/SolWash.apk)
- **GitHub Release Page:** [https://github.com/Aryan7251/solwash/releases/tag/v1.0.0](https://github.com/Aryan7251/solwash/releases/tag/v1.0.0)
- **Local Desktop File:** `/home/linux/Desktop/SolWash.apk`
- **Features Included:**
  - Custom launcher icons generated across all standard densities (`mdpi`, `hdpi`, `xhdpi`, `xxhdpi`, `xxxhdpi`).
  - Seamless integration with the live Render backend.
  - Full booking, exploration, order tracking, and profile management capabilities.

---

## 4. Local Development
To run services on your local machine:
```bash
cd /home/linux/Desktop/solwash
./start.sh   # Starts Backend (5000), Admin Panel (3000), and Mobile Web Preview (3001)
./stop.sh    # Stops all services
```

---

## 5. Summary of Recent Improvements
1. **Banner "Book Cleaning" Button:**
   - Clicking "Book Cleaning" on the home top banner opens the **"Select Solar Service"** panel with automatic top scrolling.
2. **Backend & Admin Panel Render Deployment:**
   - Render Blueprint `render.yaml` created.
   - Dynamic API base routing implemented.
   - SQLite DB resolution and automatic solar services seeders configured.
3. **App Logo & APK Packaging:**
   - Converted the custom logo image into native Android mipmap launcher icons.
   - Built the complete Android application (`assembleDebug`) via Gradle 8.5 & Java 17.
   - Released and uploaded the APK to GitHub releases.
