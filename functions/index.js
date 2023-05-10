const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp({projectId: 'unify-ef8e0'});
const geoFirestore = require('geofirestore');

const app = require('express')();
const cors = require('cors');
app.use(cors());


app.get('/matches/userAge/:userAge/maxAge/:maxAge/minAge/:minAge/matchGender/:matchGender/genderPrefs/:genderPrefs', async (req, res) =>{

    const genderPreferences = req.params.genderPrefs.split("-");
    let results = [];
    /*const getResult =
        admin.firestore().collection('users')
        .where(req.params.matchGender, "==", true)
        .where('maxAgePreference', ">=", Number(req.params.userAge))
        .where('minAgePreference', '<=', Number(req.params.userAge))
        .where('age', '<=', Number(req.params.maxAge))
        .where('age', '>=', Number(req.params.minAge))
        .where('gender', 'in', genderPreferences);
    //.get();
    //getResult.forEach(doc =>{
    //    results.push(doc.data());
    //});

     */
    const lat = 37.3882733;
    const long = -122.0778017;
    const center = new admin.firestore.GeoPoint(lat,long);

    const firestore = admin.firestore();
    const Geofirestore = geoFirestore.initializeApp(firestore);
    const geocollection = Geofirestore.collection('users')
        .where(req.params.matchGender, "==", true)
        .where('maxAgePreference', ">=", Number(req.params.userAge))
        .where('minAgePreference', '<=', Number(req.params.userAge))
        .where('age', '<=', Number(req.params.maxAge))
        .where('age', '>=', Number(req.params.minAge))
        .where('gender', 'in', genderPreferences);
    const queryCollection = geocollection.near({
        center: center,
        radius : 50,
    });


    const usersNearby = await queryCollection.get();
    usersNearby.forEach(doc => results.push(doc.data()));
    res.send(results);
});

exports.api = functions.https.onRequest(app);

