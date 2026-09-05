const { db } = require('../database/db');

// Admin Analytics & Dashboard stats
exports.getDashboardStats = async (req, res) => {
  try {
    const totalUsers = await db.getAsync("SELECT COUNT(*) as count FROM users WHERE role = 'customer'");
    const totalOrders = await db.getAsync("SELECT COUNT(*) as count FROM orders");
    const activeOrders = await db.getAsync("SELECT COUNT(*) as count FROM orders WHERE status NOT IN ('delivered', 'cancelled')");
    const totalRevenue = await db.getAsync("SELECT SUM(total_amount) as sum FROM orders WHERE payment_status = 'paid'");

    const recentOrders = await db.allAsync(`
      SELECT o.*, u.name as customer_name, s.title as service_title
      FROM orders o
      LEFT JOIN users u ON o.user_id = u.id
      LEFT JOIN services s ON o.service_id = s.id
      ORDER BY o.created_at DESC
      LIMIT 5
    `);

    const orderStatusBreakdown = await db.allAsync(`
      SELECT status, COUNT(*) as count
      FROM orders
      GROUP BY status
    `);

    // 7-Day booking trends for bar/area graph
    const weeklyTrends = await db.allAsync(`
      SELECT date(created_at) as order_date, COUNT(*) as count, COALESCE(SUM(total_amount), 0) as revenue
      FROM orders
      WHERE created_at >= date('now', '-6 days')
      GROUP BY date(created_at)
      ORDER BY order_date ASC
    `);

    // Category / Service breakdown for pie chart
    const serviceBreakdown = await db.allAsync(`
      SELECT COALESCE(s.category, 'Other') as category, COUNT(o.id) as count
      FROM orders o
      LEFT JOIN services s ON o.service_id = s.id
      GROUP BY category
    `);

    return res.json({
      success: true,
      data: {
        total_customers: totalUsers.count,
        total_orders: totalOrders.count,
        active_orders: activeOrders.count,
        revenue: totalRevenue.sum || 0.0,
        order_status_breakdown: orderStatusBreakdown,
        weekly_trends: weeklyTrends,
        service_breakdown: serviceBreakdown,
        recent_orders: recentOrders
      }
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to fetch dashboard stats.',
      error: error.message
    });
  }
};

// Admin: List all registered customers
exports.getCustomers = async (req, res) => {
  try {
    const customers = await db.allAsync(`
      SELECT id, name, email, phone, address, created_at,
        (SELECT COUNT(*) FROM orders WHERE orders.user_id = users.id) as order_count
      FROM users
      WHERE role = 'customer'
      ORDER BY created_at DESC
    `);

    return res.json({
      success: true,
      count: customers.length,
      data: customers
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to fetch customers.',
      error: error.message
    });
  }
};

// Admin: Delete user/customer
exports.deleteCustomer = async (req, res) => {
  try {
    const { id } = req.params;

    const user = await db.getAsync('SELECT * FROM users WHERE id = ?', [id]);
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found.' });
    }

    if (user.role === 'admin') {
      return res.status(403).json({ success: false, message: 'Cannot delete administrator accounts.' });
    }

    // SQLite foreign keys will cascade or delete orders associated with user
    await db.runAsync('DELETE FROM users WHERE id = ?', [id]);

    return res.json({
      success: true,
      message: `User ${user.name} (${user.email}) deleted successfully.`
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to delete user.',
      error: error.message
    });
  }
};

