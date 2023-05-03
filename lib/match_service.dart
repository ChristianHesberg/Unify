import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:unify/geolocator_server.dart';

class MatchService{
  final geo = GeoFlutterFire();
  final _firestore = FirebaseFirestore.instance;


  MatchService(){
    writeLocation();
  }

  writeLocation() async {
    Position position = await Server.determinePosition();
    GeoFirePoint myLocation = geo.point(latitude: position.latitude, longitude: position.longitude);

    _firestore
        .collection('users')
        .doc('FIzPkpXYXRQ42qwDVsMS')
        .set({'location': myLocation.data});
  }
}
// Init firestore and geoFlutterFire


