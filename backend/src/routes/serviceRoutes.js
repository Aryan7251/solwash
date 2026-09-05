const express = require('express');
const router = express.Router();
const serviceController = require('../controllers/serviceController');
const { authenticate, authorize } = require('../middleware/auth');

// Public routes
router.get('/', serviceController.getAllServices);

// Admin-only routes
router.get('/admin/all', authenticate, authorize('admin'), serviceController.getAdminServices);
router.post('/', authenticate, authorize('admin'), serviceController.createService);
router.put('/:id', authenticate, authorize('admin'), serviceController.updateService);
router.delete('/:id', authenticate, authorize('admin'), serviceController.deleteService);

module.exports = router;
