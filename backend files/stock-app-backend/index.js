const express = require('express');
const admin = require('firebase-admin');
const bodyParser = require('body-parser');
const cors = require('cors');
const serviceAccount = require('./serviceAccountKey.json');
const path = require('path');


admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const app = express();
app.use(cors());
app.use(bodyParser.json());

const uploadProfilePictureRouter = require('./routes/uploadProfilePicture');
app.use('/', uploadProfilePictureRouter);


app.use(
  '/images/profile',
  express.static(path.join(__dirname, 'uploads/profile-pictures'))
);


app.post('/getCustomToken', async (req, res) => {
  try {
    const { token } = req.body;
    console.log('Received token:', token);

    if (!token) return res.status(400).json({ error: 'Token missing' });

    const doc = await admin.firestore().collection('LoginTokens').doc(token).get();
    console.log('Firestore doc exists?', doc.exists);

    if (!doc.exists) {
      console.log('Token not found in Firestore');
      return res.status(404).json({ error: 'Token not found' });
    }

    const data = doc.data();
    console.log('Document data:', data);

    const uid = data.uid;
    const expiresAt = data.timestamp.toDate();

    if (Date.now() > expiresAt.getTime() + 5 * 60 * 1000) { // add 5 min buffer
      console.log('Token expired');
      return res.status(403).json({ error: 'Token expired' });
    }

    console.log('Deleting token from Firestore');
    await doc.ref.delete();

    console.log('Creating Firebase custom token for UID:', uid);
    const customToken = await admin.auth().createCustomToken(uid);

    console.log('Custom token generated successfully');
    return res.json({ customToken });
  } catch (err) {
    console.error('Error in /getCustomToken:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});



const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
