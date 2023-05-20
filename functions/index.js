const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp({projectId: 'unify-ef8e0'});
const geofire = require('geofire-common');
const {v4: uuidv4} = require('uuid')
const app = require('express')();
const cors = require('cors');
const {user} = require("firebase-functions/v1/auth");
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

    const result = await admin.firestore().collection('users').doc(uId).set({
        "isSetup": true,
        "name": data.name,
        "birthday": new Date(data.birthDay),
        "gender": data.gender,
        "geohash": data.geohash,
        "latitude": data.latitude,
        "longitude": data.longitude,
        "maxAgePreference": data.maxAgePreference,
        "minAgePreference": data.minAgePreference,
        "femalePreference": data.femalePreference,
        "malePreference": data.malePreference,
        "otherPreference": data.otherPreference,
        "distancePreference": data.locationPreference,
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
    const limit = 1;

    const maxAge = new Date(req.params.maxAge);
    const minAge = new Date(req.params.minAge);

    const genderPreferences = req.params.genderPrefs.split("-");

    const bounds = geofire.geohashQueryBounds(center, radiusInM);
    const promises = [];
    for (const b of bounds) {
        const getResult =
            admin.firestore().collection('users')
                .where(req.params.matchGender, "==", true)
                .where('maxAgePreference', ">=", Number(req.params.userAge))
                .where('minAgePreference', '<=', Number(req.params.userAge))
                .where('birthday', '>=', maxAge)
                .where('birthday', '<=', minAge)
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
        //res.send(genderPreferences);
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
});

app.post('/chat', async (req, res) =>  {
    const body = req.body;
    const postResult = await admin.firestore()
        .collection('chats')
        .add({
           'userIds': [body.uid1, body.uid2],
            'users': {
               'user1': {
                   'displayName': body.displayName1,
                   'uid': body.uid1
               },
                'user2': {
                   'displayName': body.displayName2,
                    'uid': body.uid2
                }
            }
        });
    return res.json(postResult);
});

app.get('/whatever', (reg, res) => {
    return res.json({mykey: "hello world"});
})

app.post('/deleteImage', async (req, res) => {
    // Get the user ID and filename from the request body
    const {userId, downloadUrl} = req.body;

    //depending on using emulators or not. download url´s are different. therefor the name have been giving an identifier _name-of-image_
    const firstIdentifier = downloadUrl.indexOf("_");
    const secondIdentifier = downloadUrl.indexOf("_", firstIdentifier + 1);
    const filename = downloadUrl.substring(firstIdentifier,secondIdentifier + 1);

    // Construct the path to the image
    const path = `users/${userId}/images/${filename}`;

    try {
        // Delete the image from Firebase Cloud Storage
        await admin.storage().bucket("gs://unify-ef8e0.appspot.com/").file(path).delete();

        await admin.firestore().collection("users").doc(userId).update({
            imageList: admin.firestore.FieldValue.arrayRemove(downloadUrl)
        });

            return res.status(200).send("image deleted successfully");
    } catch (error) {
        res.status(500).json({error: 'An error occurred while deleting the image.'});
        throw new functions.https.HttpsError('internal', 'An error occurred while deleting the image.', error);
    }
});


app.post('/uploadProfilePicture', async (req, res) => {
    try {
        const base64Image = req.body.image;
        const userId = req.body.userId;
        const bucket = admin.storage().bucket("gs://unify-ef8e0.appspot.com/");
        const fileBuffer = Buffer.from(base64Image, 'base64');
        const fileName = "profilepicture.jpg";
        const path = `users/${userId}/${fileName}`;

        const file = bucket.file(path);
        await file.save(fileBuffer, {
            metadata: {
                contentType: 'image/jpeg', // Update the content type according to your image format
            },
        });

        return res.json(fileName); // warning will return a string that will have "" inside the string.
    } catch (error) {
        res.status(500).send('Error uploading image');
        throw new functions.https.HttpsError('internal', 'An error occurred while deleting the image.', error);

    }
});

app.put('/updateUserProfilePicture', async (req, res) => {
    try {
        const downloadURL = req.body.url;
        const userId = req.body.userId;

        const userRef = admin.firestore().collection("users").doc(userId);
        await userRef.update({profilePicture: downloadURL});

        res.status(200).send("updated user");
    } catch (error) {
        res.status(500).send("Error updating user");
    }
});
app.post('/uploadImages', async (req, res) => {
    try {
        const images = req.body.images.replace("[", "").replace("]", "").replace(" ", "");
        const list = images.split(",");
        const userId = req.body.userId;
        const bucket = admin.storage().bucket("gs://unify-ef8e0.appspot.com/");

        let outputList = [];

        for (let img of list) {
            const random_uuid = uuidv4(undefined, undefined, undefined);
            const fileBuffer = Buffer.from(img, 'base64');
            const fileName = `_${random_uuid}_`;
            const path = `users/${userId}/images/${fileName}`;
            outputList.push(fileName);
            await bucket.file(path).save(fileBuffer, {
                metadata: {
                    contentType: 'image/jpeg', // Update the content type according to your image format
                },
            });
        }

        return res.json(outputList)
    } catch (error) {
        res.status(500).send('Error uploading image');
        throw new functions.https.HttpsError('internal', 'An error occurred while deleting the image.', error);
    }
});

function test() {
    print("lmao");
}


app.put('/updateUserImages', async (req, res) => {
    try {
        const urlList = req.body.urls.replace("[", "").replace("]", "").replace(" ", "");
        const downloadUrlList = urlList.split(",");
        const userId = req.body.userId;

        const userRef = admin.firestore().collection("users").doc(userId);

        for (let url of downloadUrlList){
            await userRef.update({
                imageList: admin.firestore.FieldValue.arrayUnion(url)
            });
        }

        res.status(200).send("updated user");
    } catch (error) {
        res.status(500).send("Error updating user");
    }
});


exports.api = functions.https.onRequest(app);


