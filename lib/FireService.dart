import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unify/Screens/LoginScreen.dart';
import 'package:http/http.dart' as http;

class FireService {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  //TODO HOW DO YOU CREATE ACCOUNT WITH CLOUD FUNC??
  createAccount(String username, String email, String password) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      value.user!.updateDisplayName(username);
      _auth.signInWithEmailAndPassword(email: email, password: password);
    });
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

  testGet() async {
    var result = await http.get(
        Uri.parse("http://10.0.2.2:5001/unify-ef8e0/us-central1/api/test"));

    print("RESULT: ${result.}");
  }

  updateAccount() async {
    var uId = _auth.currentUser!.uid;
    print("CURRENT USER: $uId");
    //await _fireStore.collection("users").doc(uId).set({"isSetup": true});
    var httpClint = http.Client();
    var testData = {"aaa": "asdasd"};

    var a = await http.post(
        Uri.parse(
            "http://127.0.0.1:5001/unify-ef8e0/us-central1/api/accountSetup"),
        body: {"testfield": "lmao"});
    print("AAAAAAA: $a");
  }

  static final _firestore = FirebaseFirestore.instance;
  var isSetup = false;

  checkStatus(String uId) async {
    print("---------UID: $uId");
    var userDoc = await _firestore.collection("users").doc(uId).get();
    var doc = userDoc.data();
    isSetup = doc!["isSetup"];
  }

  updateCurrentUser(String uid) async {
    //print("@@@@@@@@@@userDoccccccccc: ${userDoc.data()}");
  }
}
