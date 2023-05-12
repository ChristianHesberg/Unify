import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unify/Screens/Unify.dart';
import 'package:unify/UserState.dart';

class FireService {
  final _auth = FirebaseAuth.instance;

  //TODO HOW DO YOU CREATE ACCOUNT WITH CLOUD FUNC??
   createAccount(String username, String email, String password) async {
    _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      value.user!.updateDisplayName(username);
      _auth.signInWithEmailAndPassword(email: email, password: password);
    });
  }

   signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  void signOut(context) {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const UnifyScreen(),
      ),
    );
  }
}
