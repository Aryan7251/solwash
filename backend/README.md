# SolWash Backend Service

Production-ready Node.js REST API with built-in SQLite database, secure JWT authentication, role-based authorization (Customer & Admin), and Order Management.

---

## 🛠 Features

- **Runtime**: Node.js & Express.js
- **Built-in Database**: SQLite3 (`./src/data/solwash.db`) with automatic table creation & auto-seeding.
- **Environment & Secrets**: Managed via `.env` (with `.gitignore` to prevent secret leaks).
- **Authentication**: JWT (JSON Web Tokens) + `bcryptjs` password hashing.
- **Roles**:
  - `customer` (Register, manage profile, book wash orders, cancel pending orders)
  - `admin` (View dashboard metrics, manage services, update order & payment status)

---

## 🚀 Getting Started

### 1. Installation
```bash
cd backend
npm install
```

### 2. Environment Variables (.env)
The `.env` file is pre-configured with default values:
```env
PORT=5000
NODE_ENV=development
JWT_SECRET=solwash_super_secret_jwt_key_2026_secure_hash_98765!@#$
JWT_EXPIRES_IN=7d
DB_PATH=./src/data/solwash.db

DEFAULT_ADMIN_EMAIL=admin@solwash.com
DEFAULT_ADMIN_PASSWORD=Admin@123456
DEFAULT_ADMIN_NAME=Super Admin
DEFAULT_ADMIN_PHONE=+919876543210
```

### 3. Start Server
```bash
# Production / Standard run
npm start

# Auto-reload development mode
npm run dev
```

---

## 📚 API Endpoints Overview

### Health Check
- `GET /api/health` - Server status

### Authentication (`/api/auth`)
- `POST /api/auth/register` - Create customer account
- `POST /api/auth/login` - Login (Customer or Admin)
- `GET /api/auth/me` - Get profile (Bearer token required)
- `PUT /api/auth/me` - Update profile

### Services (`/api/services`)
- `GET /api/services` - List all active laundry services (Public)
- `GET /api/services/admin/all` - List all services including disabled (Admin)
- `POST /api/services` - Add service (Admin)
- `PUT /api/services/:id` - Update service (Admin)
- `DELETE /api/services/:id` - Delete service (Admin)

### Orders (`/api/orders`)
- `POST /api/orders` - Place laundry booking order (Customer)
- `GET /api/orders/my-orders` - Get customer's orders (Customer)
- `GET /api/orders/:id` - Get order details (Customer or Admin)
- `PUT /api/orders/:id/cancel` - Cancel pending order (Customer)
- `GET /api/orders` - View all customer orders with filters (Admin)
- `PUT /api/orders/:id/status` - Update order & payment status (Admin)

### Admin Analytics (`/api/admin`)
- `GET /api/admin/stats` - Summary statistics & revenue (Admin)
- `GET /api/admin/customers` - List customer directory (Admin)

---

## 🔑 Default Admin Login
- **Email**: `admin@solwash.com`
- **Password**: `Admin@123456`
