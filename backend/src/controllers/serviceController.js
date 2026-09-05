const { db } = require('../database/db');

// List all active services
exports.getAllServices = async (req, res) => {
  try {
    const services = await db.allAsync(
      'SELECT * FROM services WHERE is_active = 1 ORDER BY id ASC'
    );
    return res.json({
      success: true,
      count: services.length,
      data: services
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to fetch services.',
      error: error.message
    });
  }
};

// Admin: Get all services (active + inactive)
exports.getAdminServices = async (req, res) => {
  try {
    const services = await db.allAsync('SELECT * FROM services ORDER BY id DESC');
    return res.json({
      success: true,
      count: services.length,
      data: services
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to fetch services.',
      error: error.message
    });
  }
};

// Admin: Create service
exports.createService = async (req, res) => {
  try {
    const { title, description, category, base_price, price_unit } = req.body;

    if (!title || base_price === undefined) {
      return res.status(400).json({
        success: false,
        message: 'Title and base_price are required.'
      });
    }

    const result = await db.runAsync(
      `INSERT INTO services (title, description, category, base_price, price_unit, is_active)
       VALUES (?, ?, ?, ?, ?, 1)`,
      [title, description || '', category || 'general', Number(base_price), price_unit || 'per item']
    );

    const newService = await db.getAsync('SELECT * FROM services WHERE id = ?', [result.lastID]);

    return res.status(201).json({
      success: true,
      message: 'Service created successfully.',
      data: newService
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to create service.',
      error: error.message
    });
  }
};

// Admin: Update service
exports.updateService = async (req, res) => {
  try {
    const { id } = req.params;
    const { title, description, category, base_price, price_unit, is_active } = req.body;

    const existing = await db.getAsync('SELECT * FROM services WHERE id = ?', [id]);
    if (!existing) {
      return res.status(404).json({ success: false, message: 'Service not found.' });
    }

    await db.runAsync(
      `UPDATE services
       SET title = COALESCE(?, title),
           description = COALESCE(?, description),
           category = COALESCE(?, category),
           base_price = COALESCE(?, base_price),
           price_unit = COALESCE(?, price_unit),
           is_active = COALESCE(?, is_active)
       WHERE id = ?`,
      [
        title !== undefined ? title : null,
        description !== undefined ? description : null,
        category !== undefined ? category : null,
        base_price !== undefined ? Number(base_price) : null,
        price_unit !== undefined ? price_unit : null,
        is_active !== undefined ? Number(is_active) : null,
        id
      ]
    );

    const updated = await db.getAsync('SELECT * FROM services WHERE id = ?', [id]);
    return res.json({
      success: true,
      message: 'Service updated successfully.',
      data: updated
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to update service.',
      error: error.message
    });
  }
};

// Admin: Delete service
exports.deleteService = async (req, res) => {
  try {
    const { id } = req.params;
    const existing = await db.getAsync('SELECT * FROM services WHERE id = ?', [id]);
    if (!existing) {
      return res.status(404).json({ success: false, message: 'Service not found.' });
    }

    await db.runAsync('DELETE FROM services WHERE id = ?', [id]);
    return res.json({
      success: true,
      message: 'Service deleted successfully.'
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to delete service.',
      error: error.message
    });
  }
};
