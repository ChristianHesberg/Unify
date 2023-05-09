const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp({projectId: 'unify-ef8e0'});
const geofire = require('geofire-common');

const app = require('express')();
const cors = require('cors');
app.use(cors());


app.get('/matches/userAge/:userAge/maxAge/:maxAge/minAge/:minAge/matchGender/:matchGender/genderPrefs/:genderPrefs', async (req, res) =>{

    const genderPreferences = req.params.genderPrefs.split("-");
    results = [];
    const getResult =
        await admin.firestore().collection('users')
        .where(req.params.matchGender, "==", true)
        .where('maxAgePreference', ">=", req.params.userAge)
        //.where('minAgePreference', '<=', req.params.userAge)
        //.where('age', '<=', req.params.maxAge)
        //.where('age', '>=', req.params.minAge)
        //.where('gender', 'in', genderPreferences)
    .get();
    getResult.forEach(doc =>{
        results.push(doc.data());
    })
    res.send(results);
    //geofire.geohashQueryBounds()
});

exports.api = functions.https.onRequest(app);

