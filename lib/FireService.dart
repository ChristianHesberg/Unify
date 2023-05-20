import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:unify/Screens/DiscoverScreen.dart';
import 'package:unify/Screens/LoginScreen.dart';
import 'package:http/http.dart' as http;
import 'package:unify/models/SettingDTO.dart';
import 'package:unify/user_service.dart';

class FireService {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  final baseUrl = "http://10.0.2.2:5001/unify-ef8e0/us-central1/api";
  var isSetup = false;

  final UserService userService = UserService();

  createAccount(String email, String password) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((_) =>
            _auth.signInWithEmailAndPassword(email: email, password: password));
  }

  signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut(context) async {
    await FirebaseAuth.instance.signOut();
    isSetup = false;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  updateAccount(SettingsDTO dto) async {
    //TODO YOINK IMAGE UPLOAD FRA MAGNUS Transaciton pic - account update

    //await userService.uploadImages(dto.imageList);
    await userService.uploadProfilePicture(dto.profilePicture);
    Response result = await http.post(Uri.parse("$baseUrl/accountSetup"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: json.encode({
          "uId": dto.id,
          "name": dto.name,
          "birthDay": dto.age.toString(),
          "geohash": dto.position.hash,
          "latitude": dto.position.latitude,
          "longitude": dto.position.longitude,
          "gender": dto.gender,
          "maxAgePreference": dto.maxAgePreference,
          "minAgePreference": dto.minAgePreference,
          "femalePreference": dto.femalePreference,
          "malePreference": dto.malePreference,
          "otherPreference": dto.otherPreference,
          "locationPreference": dto.locationPreference,
          "description": dto.description
          //TODO PROFILE PIC
          //TODO MANY PIC
        }));

    return result.body;
  }

  checkStatus() async {
    String uId = FirebaseAuth.instance.currentUser!.uid;
    print("Checking status for uId: $uId");
    var userDoc = await _fireStore.collection("users").doc(uId).get();
    var doc = userDoc.data();
    isSetup = doc!["isSetup"];
    print("isSetup: $isSetup");
    return isSetup;
  }
}
