const HealthRecord = require('../models/HealthRecord');

// Upload Health Record
exports.uploadRecord = async (req, res) => {
    const { title, fileType } = req.body;
    try {
        if (!req.file) return res.status(400).json({ msg: 'No file uploaded' });

        const record = new HealthRecord({
            userId: req.user.id,
            title,
            fileUrl: req.file.path,
            fileType
        });
        await record.save();
        res.json(record);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
};

// Get User Health Records
exports.getUserRecords = async (req, res) => {
    try {
        const records = await HealthRecord.find({ userId: req.user.id }).sort({ uploadedAt: -1 });
        res.json(records);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
};

// Delete Health Record
exports.deleteRecord = async (req, res) => {
    try {
        await HealthRecord.findByIdAndDelete(req.params.id);
        res.json({ msg: 'Record deleted' });
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server error');
    }
};
