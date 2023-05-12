import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/user.dart';

//TODO userstate shit name mixing terms
class UserState {
  late final User? loggedInUser = null;
  static final _firestore = FirebaseFirestore.instance;

  static updateCurrentUser(String uid)  {
    var userDoc = _firestore.collection("users").doc(uid).get();
    print("userDoccccccccc: ${userDoc}");
  }
}
