import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:unify/Models/appUser.dart';

class UserService with ChangeNotifier{
  AppUser? _user;

  AppUser? get user => _user;

  Future<AppUser?> getUser() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      final userData = documentSnapshot.data();
      if (userData != null && userData is Map<String, dynamic>) {
        final String? name = userData['name'] as String?;
        final Timestamp birthday = userData['birthday'] as Timestamp;
        final String? gender = userData['gender'] as String?;
        final int? maxAge = userData['maxAgePreference'] as int?;
        final int? minAge = userData['minAgePreference'] as int?;
        final bool? femalePreference = userData['femalePreference'] as bool?;
        final bool? malePreference = userData['malePreference'] as bool?;
        final bool? otherPreference = userData['otherPreference'] as bool?;

        List<String> genderPreferenceList = [
          if (malePreference == true) 'male',
          if (femalePreference == true) 'female',
          if (otherPreference == true) 'other',
        ];

        final int? distancePreference =
        userData['distancePreference'] as int?;
        final GeoPoint? location = userData['location'] as GeoPoint?;
        final String? description = userData['description'] as String?;

        _user = AppUser(
          FirebaseAuth.instance.currentUser!.uid,
          name!,
          birthday.toDate(),
          gender!,
          maxAge!,
          minAge!,
          genderPreferenceList,
          distancePreference!.toDouble(),
          description!,
        );
        _user!.location = GeoFirePoint(location!.latitude, location.longitude);
        notifyListeners(); // Notify listeners of state change
        return _user!;
      } else {
        _user = null;
        notifyListeners();
        return Future.error("error");
      }
    } catch (e) {
      print(e);
    }
  }



}
