const Appointment = require('../models/Appointment');
const Doctor = require('../models/Doctor');
const User = require('../models/User');

// Book Appointment
exports.bookAppointment = async (req, res) => {
    const { doctorId, doctorName, date, time } = req.body;
    try {
        const user = await User.findById(req.user.id);
        const appointment = new Appointment({
            userId: req.user.id,
            doctorId,
            userName: user.name,
            doctorName,
            date,
            time
        });
        await appointment.save();
        res.json(appointment);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
};

// Get User Appointments
exports.getUserAppointments = async (req, res) => {
    try {
        const appointments = await Appointment.find({ userId: req.user.id }).sort({ createdAt: -1 });
        res.json(appointments);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
};

// Get Doctor Appointments
exports.getDoctorAppointments = async (req, res) => {
    try {
        const appointments = await Appointment.find({ doctorId: req.user.id }).sort({ createdAt: -1 });
        res.json(appointments);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
};

// Cancel Appointment
exports.cancelAppointment = async (req, res) => {
    try {
        let appointment = await Appointment.findById(req.params.id);
        if (!appointment) return res.status(404).json({ msg: 'Appointment not found' });

        appointment.status = 'Cancelled';
        await appointment.save();
        res.json({ msg: 'Appointment cancelled' });
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
};
