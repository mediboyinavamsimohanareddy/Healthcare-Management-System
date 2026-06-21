const express = require('express');
const router = express.Router();
const healthRecordController = require('../controllers/healthRecordController');
const auth = require('../middleware/auth');
const multer = require('multer');
const fs = require('fs');
const path = require('path');

// Ensure uploads directory exists
const uploadDir = path.join(__dirname, '../uploads');
if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir, { recursive: true });
}

// Multer Config
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'uploads/');
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname));
    }
});
const upload = multer({ storage });

router.post('/upload', auth, upload.single('file'), healthRecordController.uploadRecord);
router.get('/user', auth, healthRecordController.getUserRecords);
router.delete('/:id', auth, healthRecordController.deleteRecord);

module.exports = router;
