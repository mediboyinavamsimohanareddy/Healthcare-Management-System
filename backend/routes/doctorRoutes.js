const express = require('express');
const router = express.Router();
const doctorController = require('../controllers/doctorController');
const auth = require('../middleware/auth');

router.post('/register', doctorController.register); // Simplified for project
router.post('/login', doctorController.login);
router.get('/', doctorController.getAllDoctors);
router.get('/profile', auth, doctorController.getProfile);
router.put('/appointment/:id', auth, doctorController.manageAppointment);

module.exports = router;
