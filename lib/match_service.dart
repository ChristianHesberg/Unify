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
        .update({
      'geohash': user.location.hash,
      'lat': position.latitude,
      'lng': position.longitude
        });
  }

  getUsersWithinRadius() async {

  }
}