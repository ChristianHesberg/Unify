const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp({projectId: 'unify-ef8e0'});
const geofire = require('geofire-common');

const app = require('express')();
const cors = require('cors');
app.use(cors());

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
    '/lastDoc/:lastDoc' , async (req, res) =>{

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
                if(doc.id!==req.params.uid){
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
        if(req.params.lastDoc!== ':lastDoc'){
            for(let i=0; i < matchingDocs.length; i++){
                if(matchingDocs[i].id === req.params.lastDoc){
                    index = i;
                    break;
                }
            }
        }
        for(let i = 0; i <= limit; i++){
            if(matchingDocs[index + i] === undefined){
               break;
            }
            filteredDocs.push(matchingDocs[index + i]);
        }
        if(req.params.lastDoc!==':lastDoc'){
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
})

exports.api = functions.https.onRequest(app);

