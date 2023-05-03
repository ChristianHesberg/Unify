import 'dart:async';

import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:unify/geolocator_server.dart';

class MatchService{
  final geo = GeoFlutterFire();
  final _firestore = FirebaseFirestore.instance;
  late GeoFirePoint myLocation;


  MatchService() {
    writeLocation();
    getUsersWithinRadius(50);
  }

  writeLocation() async {
    Position position = await Server.determinePosition();
    myLocation = geo.point(latitude: position.latitude, longitude: position.longitude);

    _firestore
        .collection('users')
        .doc('Qu6shvN7ZElUK0ugKN8j')
        .update({'location': myLocation.data});
  }

  getUsersWithinRadius(double radius) async{
    Position position = await Server.determinePosition();
    myLocation = geo.point(latitude: position.latitude, longitude: position.longitude);
    List<dynamic> data = [];
    late StreamSubscription sub;

    var collectionReference = _firestore.collection('users');
    var geoRef = geo.collection(collectionRef: collectionReference);

    String field = 'location';

    Stream<List<DocumentSnapshot>> stream = geoRef.withinAsSingleStreamSubscription
      (center: myLocation, radius: radius, field: field);
    sub = stream.listen((event) {
      event.forEach((element) {
        data.add(element.data());
        print(data);
      });
      sub.cancel();
    });
  }
}
// Init firestore and geoFlutterFire


