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

import 'models/baseUrl.dart';

class FireService {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  final UserService userService = UserService();

  createAccount(String email, String password) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((_) {
      _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    });
  }

  signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut(context) async {
    await _auth.signOut();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  updateAccount(SettingsDTO dto) async {
    Response result = await http.post(
        Uri.parse("${BaseUrl.baseUrl}accountSetup"),
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
        }));
    await userService.uploadImages(dto.imageList);
    await userService.uploadProfilePicture(dto.profilePicture);
    return result.body;
  }

  Future<bool> checkStatus() async {
    var isSetup = false;
    try {
      String uId = FirebaseAuth.instance.currentUser!.uid;
      var userDoc = await _fireStore.collection("users").doc(uId).get();
      var doc = userDoc.data();
      isSetup = doc!["isSetup"];
    } catch (e) {
      return false;
    }
    return isSetup;
  }
}
