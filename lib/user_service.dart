import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:unify/Models/appUser.dart';
import 'package:unify/Models/appImage.dart';

class UserService with ChangeNotifier{
  AppUser? _user;

  AppUser? get user => _user;

  void getUser() async {
    try {
      //logged in user id
      String uid = FirebaseAuth.instance.currentUser!.uid;

      //query
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      //data handle
      final userData = documentSnapshot.data();
      if (userData != null) {
        final String? name = userData['name'] as String?;
        final Timestamp birthday = userData['birthday'] as Timestamp;
        final double lat = userData['lat'];
        final double lng = userData['lng'];
        final String? gender = userData['gender'] as String?;
        final int? maxAge = userData['maxAgePreference'] as int?;
        final int? minAge = userData['minAgePreference'] as int?;
        final bool? femalePreference = userData['femalePreference'] as bool?;
        final bool? malePreference = userData['malePreference'] as bool?;
        final bool? otherPreference = userData['otherPreference'] as bool?;

        // setup gender preference list
        List<String> genderPreferenceList = [
          if (malePreference == true) 'male',
          if (femalePreference == true) 'female',
          if (otherPreference == true) 'other',
        ];

        final int? distancePreference =
        userData['distancePreference'] as int?;
        final GeoPoint? location = userData['location'] as GeoPoint?;
        final String? description = userData['description'] as String?;

        // get pictures
        String profilePicture = await downloadImage(uid, "profilepicture");
        List<AppImage> image = await getImagesInFolder(uid);


    _user = AppUser(
          uid,
          name!,
          birthday.toDate(),
          lat,
          lng,
          gender!,
          maxAge!,
          minAge!,
          genderPreferenceList,
          distancePreference!,
          profilePicture,
          description!,
          image
        );

    //set user location

        notifyListeners(); // Notify listeners of state change
      } else {
        _user = null;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }
  
  Future<String> downloadImage(String userId, String imageName) async {
    // Create a reference to the Firebase Storage location of the image

    String path = 'users/$userId/$imageName.jpg';
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child(path);

    return await storageReference.getDownloadURL();
  }

  Future<List<AppImage>> getImagesInFolder(String uid) async {
    Reference storageReference = FirebaseStorage.instance.ref("users/$uid/images");

    ListResult result = await storageReference.listAll();

    List<AppImage> urlList = [];
    for (Reference ref in result.items) {
      // Get the download URL for each image
      String downloadUrl = await ref.getDownloadURL();
      String imageName = ref.name;
      urlList.add(AppImage(downloadUrl, imageName));
    }
    return urlList;
  }
}
