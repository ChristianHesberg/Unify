import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:unify/geolocator_server.dart';
import 'Models/appUser.dart';

class MatchService{
  final geo = GeoFlutterFire();
  final _firestore = FirebaseFirestore.instance;
  late AppUser user;


  MatchService() {
    user = AppUser(
        'SdeTTfnQG52HM97YnsKs',
        'crissy',
        DateTime.now(),
        'female',
        23,
        27,
        ['male','female'],
        50,
        "fefewfew");
    _firestore.useFirestoreEmulator('localhost', 8080);
    //writeLocation();
    //getUsersWithinRadius();
  }

  writeLocation() async {
    Position position = await Server.determinePosition();
    user.location = geo.point(latitude: position.latitude, longitude: position.longitude);

    _firestore
        .collection('users')
        .doc(user.id)
        .update({'location': user.location.data});
  }

  /*getUsersWithinRadius() async{
    Position position = await Server.determinePosition();
    user.location = geo.point(latitude: position.latitude, longitude: position.longitude);
    List<dynamic> data = [];
    late StreamSubscription sub;
    String field = 'location';
    String genderPreference = determineGenderPreference();

    var collectionReference = _firestore.collection('users')
        .where(genderPreference, isEqualTo: true)
        .where('maxAgePreference', isGreaterThanOrEqualTo: user.age)
        .where('minAgePreference', isLessThanOrEqualTo: user.age)
        .where('age', isLessThanOrEqualTo: user.maxAgePreference)
        .where('age', isGreaterThanOrEqualTo: user.minAgePreference)
        .where('gender', whereIn: user.genderPreferences);
    var geoRef = geo.collection(collectionRef: collectionReference);

    Stream<List<DocumentSnapshot>> stream = geoRef.withinAsSingleStreamSubscription
      (center: user.location, radius: user.locationPreference, field: field);
    sub = stream.listen((event) {
      event.forEach((element) {
          print(element.data());
      });
      sub.cancel();
    });
  }

  determineGenderPreference() {
    switch(user.gender){
      case 'male': return 'malePreference';
      case 'female': return 'femalePreference';
      case 'other': return 'otherGenderPreference';
    }
  }
  
   */

}