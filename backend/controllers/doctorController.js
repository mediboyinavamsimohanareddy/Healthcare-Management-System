const Doctor = require('../models/Doctor');
const Appointment = require('../models/Appointment');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// Register Doctor (Admin usually does this, but for simplicity we add it here)
exports.register = async (req, res) => {
    const { name, email, password, specialty, experience, phone } = req.body;
    try {
        let doctor = await Doctor.findOne({ email });
        if (doctor) return res.status(400).json({ msg: 'Doctor already exists' });

        doctor = new Doctor({ name, email, password, specialty, experience, phone });
        const salt = await bcrypt.genSalt(10);
        doctor.password = await bcrypt.hash(password, salt);

        await doctor.save();
        res.json({ msg: 'Doctor registered successfully' });
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
};

// Login Doctor
exports.login = async (req, res) => {
    const { email, password } = req.body;
    try {
        let doctor = await Doctor.findOne({ email });
        if (!doctor) return res.status(400).json({ msg: 'Invalid Credentials' });

        const isMatch = await bcrypt.compare(password, doctor.password);
        if (!isMatch) return res.status(400).json({ msg: 'Invalid Credentials' });

        const payload = { user: { id: doctor.id, role: 'doctor' } };
        jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '7d' }, (err, token) => {
            if (err) throw err;
            res.json({ token });
        });
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
};

// Get All Doctors
exports.getAllDoctors = async (req, res) => {
    try {
        const doctors = await Doctor.find().select('-password');
        res.json(doctors);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
};

// Get Doctor Profile
exports.getProfile = async (req, res) => {
    try {
        const doctor = await Doctor.findById(req.user.id).select('-password');
        res.json(doctor);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
};

// Manage Appointment (Accept/Reject)
exports.manageAppointment = async (req, res) => {
    const { status } = req.body; // 'Accepted' or 'Rejected'
    try {
        let appointment = await Appointment.findById(req.params.id);
        if (!appointment) return res.status(404).json({ msg: 'Appointment not found' });

        appointment.status = status;
        await appointment.save();
        res.json(appointment);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
};
