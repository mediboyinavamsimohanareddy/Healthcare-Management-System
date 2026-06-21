const express = require('express');
const router = express.Router();
const appointmentController = require('../controllers/appointmentController');
const auth = require('../middleware/auth');

router.post('/book', auth, appointmentController.bookAppointment);
router.get('/user', auth, appointmentController.getUserAppointments);
router.get('/doctor', auth, appointmentController.getDoctorAppointments);
router.put('/cancel/:id', auth, appointmentController.cancelAppointment);

module.exports = router;
