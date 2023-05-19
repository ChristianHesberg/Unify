import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:unify/models/appUser.dart';
import 'package:http/http.dart' as http;
import 'geolocator_server.dart';

class UserService with ChangeNotifier{
  AppUser? _user;
  final geo = GeoFlutterFire();
  final _firestore = FirebaseFirestore.instance;
  static const baseUrl = 'http://10.0.2.2:5001/unify-ef8e0/us-central1/api/';
  String lastDoc = ':lastDoc';

  AppUser? get user => _user;


  Future<AppUser?> initializeUser() async {
    if(user==null){
      await getUser();
    }
    return _user;
  }

  Future<AppUser?> getUser() async {
      //logged in user id
      String uid = FirebaseAuth.instance.currentUser!.uid;

      //set user location
      _writeLocation();

      //query
      final DocumentSnapshot<Map<String, dynamic>> userData =
      await _firestore
          .collection('users')
          .doc(uid)
          .get();

      //data handle
      _user = AppUser.fromMap(userData.id, userData.data()!);

      notifyListeners();// Notify listeners of state change
      print(uid);
      print(_user);
      return _user;

  }

  _writeLocation() async {
    Position position = await Server.determinePosition();
    var point = geo.point(latitude: position.latitude, longitude: position.longitude);

    _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'geohash': point.hash,
      'lat': position.latitude,
      'lng': position.longitude
    });
  }

  getUsersWithinRadius() async {
    final response = await http.get(
        Uri.parse(urlBuilder())
    );
    List<AppUser> result = [];
    var body = json.decode(response.body);
    for (var map in body) {
      result.add(AppUser.fromMapJson(map['id'], map['data']));
    }
    lastDoc = result[result.length-1].id;
    return result;
  }

  urlBuilder(){
    return baseUrl + 'matches' +
        '/userAge/' + _user!.getBirthdayAsAge().toString() +
        '/maxAge/' + _user!.getMaxAgePrefAsBirthday() +
        '/minAge/' + _user!.getMinAgePrefAsBirthday() +
        '/matchGender/' + _user!.getGenderAsPreference() +
        '/genderPrefs/' + _user!.getGenderPreferencesAsString() +
        '/uid/' + _user!.id +
        '/lat/' + _user!.lat.toString() +
        '/lng/' + _user!.lng.toString() +
        '/radius/' + _user!.locationPreference.toString() +
        '/lastDoc/' + lastDoc;
  }
  
  Future<String> downloadImage(String userId, String imageName) async {
    // Create a reference to the Firebase Storage location of the image

    String path = 'users/$userId/$imageName.jpg';
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child(path);

    return await storageReference.getDownloadURL();
  }

  Future<List<String>> getImagesInFolder(String uid) async {
    Reference storageReference = FirebaseStorage.instance.ref("users/$uid/images");

    ListResult result = await storageReference.listAll();

    List<String> urlList = [];
    for (Reference ref in result.items) {
      // Get the download URL for each image
      String downloadUrl = await ref.getDownloadURL();
      String imageName = ref.name;
      urlList.add(downloadUrl);
    }
    return urlList;
  }
}
