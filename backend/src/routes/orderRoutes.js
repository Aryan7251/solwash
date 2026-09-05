const express = require('express');
const router = express.Router();
const orderController = require('../controllers/orderController');
const { authenticate, authorize } = require('../middleware/auth');

// Customer routes
router.post('/', authenticate, orderController.createOrder);
router.get('/my-orders', authenticate, orderController.getMyOrders);
router.put('/:id/cancel', authenticate, orderController.cancelOrder);

// Shared (Customer can view own order, Admin can view any)
router.get('/:id', authenticate, orderController.getOrderById);

// Admin-only routes
router.get('/', authenticate, authorize('admin'), orderController.getAllOrders);
router.put('/:id/status', authenticate, authorize('admin'), orderController.updateOrderStatus);
router.delete('/:id', authenticate, authorize('admin'), orderController.deleteOrder);

module.exports = router;
