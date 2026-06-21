const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');
const auth = require('../middleware/auth');

router.post('/login', adminController.login);
router.get('/stats', auth, adminController.getStats);
router.delete('/user/:id', auth, adminController.deleteUser);
router.delete('/doctor/:id', auth, adminController.deleteDoctor);

module.exports = router;
