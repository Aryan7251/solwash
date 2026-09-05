const sqlite3 = require('sqlite3').verbose();
const path = require('path');
const fs = require('fs');
const bcrypt = require('bcryptjs');
const env = require('../config/env');

const dbDir = path.resolve(__dirname, '../data');
if (!fs.existsSync(dbDir)) {
  fs.mkdirSync(dbDir, { recursive: true });
}

const dbFilePath = path.resolve(process.cwd(), env.DB_PATH);
const db = new sqlite3.Database(dbFilePath, (err) => {
  if (err) {
    console.error('Error connecting to SQLite database:', err.message);
  } else {
    console.log(`Connected to built-in SQLite database at: ${dbFilePath}`);
  }
});

// Promisified helper methods for database operations
db.runAsync = function (sql, params = []) {
  return new Promise((resolve, reject) => {
    db.run(sql, params, function (err) {
      if (err) reject(err);
      else resolve({ lastID: this.lastID, changes: this.changes });
    });
  });
};

db.getAsync = function (sql, params = []) {
  return new Promise((resolve, reject) => {
    db.get(sql, params, (err, row) => {
      if (err) reject(err);
      else resolve(row);
    });
  });
};

db.allAsync = function (sql, params = []) {
  return new Promise((resolve, reject) => {
    db.all(sql, params, (err, rows) => {
      if (err) reject(err);
      else resolve(rows);
    });
  });
};

// Database Initialization & Schema Definition
const initDatabase = async () => {
  try {
    // Foreign keys support
    await db.runAsync('PRAGMA foreign_keys = ON');

    // 1. Users Table
    await db.runAsync(`
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        phone TEXT,
        password TEXT NOT NULL,
        role TEXT DEFAULT 'customer' CHECK(role IN ('customer', 'admin', 'rider')),
        address TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    `);

    // 2. Services Table (Dry clean, Wash & Fold, Steam Press, Shoe Cleaning, etc.)
    await db.runAsync(`
      CREATE TABLE IF NOT EXISTS services (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        category TEXT DEFAULT 'general',
        base_price REAL NOT NULL,
        price_unit TEXT DEFAULT 'per item',
        is_active INTEGER DEFAULT 1,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    `);

    // 3. Orders Table
    await db.runAsync(`
      CREATE TABLE IF NOT EXISTS orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_number TEXT UNIQUE NOT NULL,
        user_id INTEGER NOT NULL,
        service_id INTEGER,
        pickup_date TEXT NOT NULL,
        pickup_slot TEXT NOT NULL,
        delivery_date TEXT,
        pickup_address TEXT NOT NULL,
        customer_phone TEXT,
        latitude REAL,
        longitude REAL,
        notes TEXT,
        status TEXT DEFAULT 'pending' CHECK(status IN ('pending', 'confirmed', 'picked_up', 'in_process', 'ready', 'out_for_delivery', 'delivered', 'cancelled')),
        total_amount REAL DEFAULT 0.0,
        payment_status TEXT DEFAULT 'pending' CHECK(payment_status IN ('pending', 'paid', 'failed', 'refunded')),
        payment_mode TEXT DEFAULT 'cash_on_delivery',
        razorpay_order_id TEXT,
        razorpay_payment_id TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (service_id) REFERENCES services (id) ON DELETE SET NULL
      )
    `);

    // Migration for existing tables
    try { await db.runAsync('ALTER TABLE orders ADD COLUMN customer_phone TEXT'); } catch (e) {}
    try { await db.runAsync('ALTER TABLE orders ADD COLUMN latitude REAL'); } catch (e) {}
    try { await db.runAsync('ALTER TABLE orders ADD COLUMN longitude REAL'); } catch (e) {}
    try { await db.runAsync('ALTER TABLE orders ADD COLUMN razorpay_order_id TEXT'); } catch (e) {}
    try { await db.runAsync('ALTER TABLE orders ADD COLUMN razorpay_payment_id TEXT'); } catch (e) {}

    // 4. Order Items Table
    await db.runAsync(`
      CREATE TABLE IF NOT EXISTS order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER NOT NULL,
        item_name TEXT NOT NULL,
        quantity INTEGER NOT NULL DEFAULT 1,
        unit_price REAL NOT NULL,
        total_price REAL NOT NULL,
        FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE
      )
    `);

    // 5. OTPs Table for Email OTP Login
    await db.runAsync(`
      CREATE TABLE IF NOT EXISTS otps (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL,
        otp TEXT NOT NULL,
        expires_at INTEGER NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    `);

    // 6. Seed default admin if not exists
    const existingAdmin = await db.getAsync(
      'SELECT id FROM users WHERE email = ?',
      [env.DEFAULT_ADMIN.email]
    );

    if (!existingAdmin) {
      const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash(env.DEFAULT_ADMIN.password, salt);
      await db.runAsync(
        `INSERT INTO users (name, email, phone, password, role, address)
         VALUES (?, ?, ?, ?, 'admin', 'SolWash HQ')`,
        [env.DEFAULT_ADMIN.name, env.DEFAULT_ADMIN.email, env.DEFAULT_ADMIN.phone, hashedPassword]
      );
      console.log(`Default admin created: ${env.DEFAULT_ADMIN.email}`);
    }

    // Ready
    console.log('Database tables verified and ready.');
  } catch (err) {
    console.error('Error during database initialization:', err);
  }
};

module.exports = {
  db,
  initDatabase
};
