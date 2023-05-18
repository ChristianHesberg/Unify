const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp({projectId: 'unify-ef8e0'});
const geofire = require('geofire-common');


const app = require('express')();
const cors = require('cors');
const formidable = require("formidable-serverless");
app.use(cors());


exports.lmao2 = functions.https.onCall((req, res) => {
    const myMap = {"fuck": "ass"};

    res.send(myMap);
})

exports.authOnAccountCreate = functions.auth
    .user()
    .onCreate((user, context) => {
        admin.firestore().collection("users").doc(user.uid)
            .set({
                isSetup: false
            })

    })

app.post("/uploadProfilePic", async (req, res) => {
        try {
            // Extract the image file from the request payload
            const file = req.files.image;

            // Generate a unique filename using UUID
            const filename = `${uuidv4()}_${file.name}`;

            // Create a temporary local file path
            const tempFilePath = path.join(os.tmpdir(), filename);

            // Save the file locally
            file.mv(tempFilePath, async (err) => {
                if (err) {
                    console.error('Error while saving file locally:', err);
                    return res.status(500).send('Error occurred while saving file.');
                }

                try {
                    // Upload the file to Firestore
                    const bucket = admin.storage().bucket();
                    await bucket.upload(tempFilePath, {
                        destination: `images/${filename}`,
                        metadata: {
                            contentType: file.mimetype,
                        },
                    });

                    // Get the public URL of the uploaded image
                    const imageUrl = `https://storage.googleapis.com/${bucket.name}/images/${filename}`;

                    // Save the image URL to Firestore
                    const firestore = admin.firestore();
                    await firestore.collection('images').add({
                        imageUrl: imageUrl,
                    });

                    // Return a success response
                    return res.status(200).send('Image uploaded successfully!');
                } catch (error) {
                    console.error('Error while uploading file to Firestore:', error);
                    return res.status(500).send('Error occurred while uploading file.');
                } finally {
                    // Delete the temporary local file
                    fs.unlinkSync(tempFilePath);
                }
            });
        } catch (error) {
            console.error('Error occurred:', error);
            return res.status(500).send('Error occurred while processing request.');
        }
    }
);

app.post("/accountSetup", async (req, res) => {
    const uId = req.body.uId;
    const data = req.body;
    var x = new File()

    const result = await admin.firestore().collection('users').doc(uId).set({
        "isSetup": true,
        "name": data.name,
        "birthDay": data.birthDay,
        "gender": data.gender,
        "geohash": data.geohash,
        "latitude": data.latitude,
        "longitude": data.longitude,
        "maxAgePreference": data.maxAgePreference,
        "minAgePreference": data.minAgePreference,
        "femalePreference": data.femalePreference,
        "malePreference": data.malePreference,
        "otherPreference": data.otherPreference,
        "locationPreference": data.locationPreference,
        "description": data.description
        //TODO PROFILE PIC
        //TODO MANY PIC
    })
    return res.json(result)
})
app.get('/matches' +
    '/userAge/:userAge' +
    '/maxAge/:maxAge' +
    '/minAge/:minAge' +
    '/matchGender/:matchGender' +
    '/genderPrefs/:genderPrefs' +
    '/uid/:uid' +
    '/lat/:lat' +
    '/lng/:lng' +
    '/radius/:radius' +
    '/lastDoc/:lastDoc', async (req, res) => {

    const lat = Number(req.params.lat);
    const lng = Number(req.params.lng);
    const center = [lat, lng];
    const radiusInM = Number(req.params.radius) * 1000;
    const limit = 10;

    const genderPreferences = req.params.genderPrefs.split("-");

    const bounds = geofire.geohashQueryBounds(center, radiusInM);
    const promises = [];
    for (const b of bounds) {
        const getResult =
            admin.firestore().collection('users')
                .where(req.params.matchGender, "==", true)
                .where('maxAgePreference', ">=", Number(req.params.userAge))
                .where('minAgePreference', '<=', Number(req.params.userAge))
                .where('age', '<=', Number(req.params.maxAge))
                .where('age', '>=', Number(req.params.minAge))
                .where('gender', 'in', genderPreferences)
                .orderBy('geohash')
                .startAt(b[0])
                .endAt(b[1]);

        promises.push(getResult.get());
    }

    Promise.all(promises).then((snapshots) => {
        const matchingDocs = [];
        let filteredDocs = [];

        for (const snap of snapshots) {
            for (const doc of snap.docs) {
                const lat = doc.get('lat');
                const lng = doc.get('lng');

                const distanceInKm = geofire.distanceBetween([Number(lat), Number(lng)], center);
                const distanceInM = distanceInKm * 1000;
                if (doc.id !== req.params.uid) {
                    if (distanceInM <= radiusInM) {
                        matchingDocs.push({
                            id: doc.id,
                            data: doc.data()
                        });
                    }
                }
            }
        }
        var index = 0;
        if (req.params.lastDoc !== ':lastDoc') {
            for (let i = 0; i < matchingDocs.length; i++) {
                if (matchingDocs[i].id === req.params.lastDoc) {
                    index = i;
                    break;
                }
            }
        }
        for (let i = 0; i <= limit; i++) {
            if (matchingDocs[index + i] === undefined) {
                break;
            }
            filteredDocs.push(matchingDocs[index + i]);
        }
        if (req.params.lastDoc !== ':lastDoc') {
            filteredDocs = filteredDocs.slice(1);
        }
        res.send(filteredDocs);
    })
});
app.post('/message', async (req, res) => {
    const body = req.body;
    const postResult = await admin.firestore()
        .collection('chats')
        .doc(body.chatId)
        .collection('messages')
        .add({
            content: body.content,
            sender: body.sender,
            timestamp: new Date()
        });
    return res.json(postResult);
})

exports.api = functions.https.onRequest(app);


