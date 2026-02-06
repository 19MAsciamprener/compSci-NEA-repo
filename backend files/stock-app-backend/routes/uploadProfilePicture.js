const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const verifyFirebaseToken = require('../middleware/verifyFirebaseToken');

const router = express.Router();

const uploadDir = path.join(__dirname, '../uploads/profile-pictures');
fs.mkdirSync(uploadDir, { recursive: true });

const storage = multer.diskStorage({
  destination: uploadDir,
  filename: (req, file, cb) => {
    cb(null, `${req.uid}.jpg`);
  },
});

const upload = multer({ storage });

router.post(
  '/uploadProfilePicture',
  verifyFirebaseToken,
  upload.single('image'),
  (req, res) => {
    res.json({
      success: true,
      imageUrl: `/images/profile/${req.uid}.jpg`,
    });
  }
);

module.exports = router;
