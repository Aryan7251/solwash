const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');
const { authenticate, authorize } = require('../middleware/auth');

router.use(authenticate, authorize('admin'));

router.get('/stats', adminController.getDashboardStats);
router.get('/customers', adminController.getCustomers);
router.delete('/customers/:id', adminController.deleteCustomer);

module.exports = router;
