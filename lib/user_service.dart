import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:unify/models/appUser.dart';
import 'package:unify/models/baseUrl.dart';
import 'geolocator_server.dart';

class UserService with ChangeNotifier {
  AppUser? _user;
  final geo = GeoFlutterFire();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String lastDoc = ':lastDoc';

  AppUser? get user => _user;


  Future<AppUser?> initializeUser() async {
    if (user == null) {
      await getUser();
    }
    return _user;
  }

  Future<AppUser?> getUser() async {
    try {
      //logged in user id
      String uid = _auth.currentUser!.uid;

      //set user location
      _writeLocation();

      //query

      final DocumentSnapshot<Map<String, dynamic>> userData =
          await _firestore.collection('users').doc(uid).get();

      //data handle
      _user = AppUser.fromMap(userData.id, userData.data()!);

      notifyListeners(); // Notify listeners of state change
      return _user;
    } catch (e) {
      print("Error in get user: $e");
    }
  }

  _writeLocation() async {
    Position position = await Server.determinePosition();
    var point =
        geo.point(latitude: position.latitude, longitude: position.longitude);

    var token = await _auth.currentUser!.getIdToken();
    await http.put(
        Uri.parse('${BaseUrl.baseUrl}writeLocation'),
        headers: {
          HttpHeaders.authorizationHeader: token,
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'hash': point.hash,
          'lat': point.latitude.toString(),
          'lng': point.longitude.toString()
      })
    );
  }

  getUsersWithinRadius() async {
    final response = await http.get(
      Uri.parse(urlBuilder()),
      headers: {
        HttpHeaders.authorizationHeader: await _auth.currentUser!.getIdToken()
      }
    );
    List<AppUser> result = [];
    var body = json.decode(response.body);
    for (var map in body) {
      if(!_user!.blacklist.contains(map['id'])){
        result.add(AppUser.fromMapJson(map['id'], map['data']));
      }
    }
    if (result.isNotEmpty) {
      lastDoc = result[result.length - 1].id;
    }
    return result;
  }

  urlBuilder() {
    return BaseUrl.baseUrl +
        'matches' +
        '/userAge/' +
        _user!.getBirthdayAsAge().toString() +
        '/maxAge/' +
        _user!.getMaxAgePrefAsBirthday() +
        '/minAge/' +
        _user!.getMinAgePrefAsBirthday() +
        '/matchGender/' +
        _user!.getGenderAsPreference() +
        '/genderPrefs/' +
        _user!.getGenderPreferencesAsString() +
        '/uid/' +
        _user!.id +
        '/lat/' +
        _user!.lat.toString() +
        '/lng/' +
        _user!.lng.toString() +
        '/radius/' +
        _user!.locationPreference.toString() +
        '/lastDoc/' +
        lastDoc;
  }

  Future<String> downloadImage(String userId, String imageName) async {
    // Create a reference to the Firebase Storage location of the image

    String path = 'users/$userId/$imageName';

    Reference storageReference = FirebaseStorage.instance.ref().child(path);

    return await storageReference.getDownloadURL();
  }

  Future<List<String>> downloadMultipleImages(
      String userId, List<String> filenameList) async {
    // Create a reference to the Firebase Storage location of the image

    Reference test = FirebaseStorage.instance.ref();
    List<String> downloadUrlList = [];

    for (String filename in filenameList) {
      String path = 'users/$userId/images/$filename';
      downloadUrlList.add(await test.child(path).getDownloadURL());
    }
    return downloadUrlList;
  }

  Future<void> deleteImage(String userId, String downloadUrl) async {
    const url = '${BaseUrl.baseUrl}deleteImage';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId, 'downloadUrl': downloadUrl}),
      );

      if (response.statusCode == 200) {
        print(json
            .decode(response.body)['message']); // Image deleted successfully.
      } else {
        print('Error deleting image: ${response.body}');
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  Future<void> uploadProfilePicture(XFile image) async {
    const url =
        '${BaseUrl.baseUrl}uploadProfilePicture';
    try {
      String base64Image = base64Encode(await image.readAsBytes());

      await http.post(
        Uri.parse(url),
        body: {
          'image': base64Image,
          'userId': FirebaseAuth.instance.currentUser!.uid
        },
      ).then((value) => {
            updateUserProfilePicture(value.body.replaceAll('"', ""))
                .then((value) => getUser()),
          });
    } catch (e) {
      print("error in uploadProfilePicture: $e");
    }
  }

  Future<void> updateUserProfilePicture(String fileName) async {
    final uId = FirebaseAuth.instance.currentUser!.uid;
    const url =
        '${BaseUrl.baseUrl}updateUserProfilePicture';
    try {
      String downloadUrl = await downloadImage(uId, fileName);

      await http.put(
        Uri.parse(url),
        body: {'url': downloadUrl, 'userId': uId},
      );
    } catch (e) {
      print("Error in updateUserProfilePicture: $e");
    }
  }

  Future<void> uploadImages(List<XFile> images) async {
    const url = '${BaseUrl.baseUrl}uploadImages';
    try {
      List<String> base64Images = [];
      for (XFile img in images) {
        base64Images.add(base64Encode(await img.readAsBytes()));
      }

      Map<String, dynamic> map;//TODO WHAT IS MAP??
      await http.post(
        Uri.parse(url),
        body: {
          'images': base64Images.toString(),
          'userId': FirebaseAuth.instance.currentUser!.uid
        },
      ).then((value) => {
            updateUserImages(json.decode(value.body).cast<String>().toList())
                .then((value) => getUser())
          });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> updateUserImages(List<String> fileNames) async {
    final uId = FirebaseAuth.instance.currentUser!.uid;
    const url =
        '${BaseUrl.baseUrl}updateUserImages';
    try {
      List<String> downloadUrl =
          await downloadMultipleImages(uId, fileNames);
      await http.put(
        Uri.parse(url),
        body: {'urls': downloadUrl.toString(), 'userId': uId},
      );
    } catch (e) {
      print("Error in updateuserimages: $e");
    }
  }

  Future<void> updateUserInfo(String description, String gender, DateTime birthday) async {
    const url =
        '${BaseUrl.baseUrl}updateUserInfo';

    try {

      await http.put(
        Uri.parse(url),
        body: {
          'description': description,
          'gender': gender,
          'birthday': birthday.toString(),
          'userId': _user!.id
        },
      );
      getUser();
    } catch (e) {
      print(e);
    }
  }


  Future<void> updateUserPreference(int minAgePreference, int maxAgePreference, bool femalePreference,bool malePreference, bool otherPreference, int distancePreference ) async {
    const url =
        '${BaseUrl.baseUrl}updateUserPreference';

    try {
      await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: json.encode({
          'minAgePreference': minAgePreference,
          'maxAgePreference': maxAgePreference,
          'femalePreference': femalePreference,
          'malePreference': malePreference,
          'otherPreference': otherPreference,
          'distancePreference': distancePreference,

          'userId': _user!.id
        }),
      );
      getUser();
    } catch (e) {
      print(e);
    }
  }
}
