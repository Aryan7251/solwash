const express = require('express');
const router = express.Router();
const paymentController = require('../controllers/paymentController');
const { authenticate } = require('../middleware/auth');

// Protected payment routes
router.post('/razorpay-order', authenticate, paymentController.createRazorpayOrder);
router.post('/verify', authenticate, paymentController.verifyPayment);

// Public webhook route for Razorpay automated event notifications
router.post('/webhook', paymentController.handleWebhook);

module.exports = router;
