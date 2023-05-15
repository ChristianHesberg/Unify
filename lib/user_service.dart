

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unify/Models/appUser.dart';

class UserService{

  Future<AppUser> getUser() async {

    final DocumentReference userDocument = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
    final DocumentSnapshot documentSnapshot = await userDocument.get();

       final userData = documentSnapshot.data();
      if (userData != null && userData is Map<String, Object?>) {
        final String? name = userData['name'] as String?;

        AppUser user = AppUser(FirebaseAuth.instance.currentUser!.uid,
            name!, DateTime.now(), "man", 32, 21, ["man"], 32);
        return user;
      }
    return Future.error("not found");
  }

}