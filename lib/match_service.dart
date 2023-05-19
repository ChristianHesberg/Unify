import 'dart:convert';

import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:unify/geolocator_server.dart';
import 'package:http/http.dart' as http;

import 'models/appUser.dart';


class MatchService{
  final geo = GeoFlutterFire();
  final _firestore = FirebaseFirestore.instance;
  static const baseUrl = 'http://10.0.2.2:5001/unify-ef8e0/us-central1/api/';
  String lastDoc = ':lastDoc';

  writeLocation(AppUser user) async {
    Position position = await Server.determinePosition();
    var point = geo.point(latitude: position.latitude, longitude: position.longitude);

    _firestore
        .collection('users')
        .doc(user.id)
        .update({
      'geohash': point.hash,
      'lat': position.latitude,
      'lng': position.longitude
        });
  }

  getUsersWithinRadius(AppUser user) async {
    final response = await http.get(
      Uri.parse(urlBuilder(user))
    );
    List<AppUser> result = [];
    var body = json.decode(response.body);
    for (var map in body) {
      result.add(AppUser.fromMap(map['id'], map['data']));
    }
    lastDoc = result[result.length-1].id;
    return result;
  }

  urlBuilder(AppUser user){
    return baseUrl + 'matches' +
        '/userAge/' + user.getBirthdayAsAge().toString() +
        '/maxAge/' + user.getMaxAgePrefAsBirthday() +
        '/minAge/' + user.getMinAgePrefAsBirthday() +
        '/matchGender/' + user.getGenderAsPreference() +
        '/genderPrefs/' + user.getGenderPreferencesAsString() +
        '/uid/' + user.id +
        '/lat/' + user.lat.toString() +
        '/lng/' + user.lng.toString() +
        '/radius/' + user.locationPreference.toString() +
        '/lastDoc/' + lastDoc;
  }
}