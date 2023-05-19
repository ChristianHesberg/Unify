import 'dart:convert';
import 'dart:convert';
import 'dart:convert';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unify/Models/appUser.dart';
import 'package:unify/Models/images.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService with ChangeNotifier {
  AppUser? _user;

  AppUser? get user => _user;

  void getUser() async {
    try {
      //logged in user id
      String uid = FirebaseAuth.instance.currentUser!.uid;

      //query
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      //data handle
      final userData = documentSnapshot.data();
      if (userData != null) {
        final String? name = userData['name'] as String?;
        final Timestamp birthday = userData['birthday'] as Timestamp;
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

        final int? distancePreference = userData['distancePreference'] as int?;
        final GeoPoint? location = userData['location'] as GeoPoint?;
        final String? description = userData['description'] as String?;
        final String? profilePicture = userData['profilePicture'] as String?;
        final List<dynamic>? images = userData['imageList'] as List<dynamic>?;

        _user = AppUser(
            uid,
            name!,
            birthday.toDate(),
            gender!,
            maxAge!,
            minAge!,
            genderPreferenceList,
            distancePreference!.toDouble(),
            profilePicture!,
            description!,
            images!);

        //set user location
        _user!.location = GeoFirePoint(location!.latitude, location.longitude);

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

    String path = 'users/$userId/$imageName';
    Reference storageReference = FirebaseStorage.instance.ref().child(path);

    return await storageReference.getDownloadURL();
  }

  Future<List<String>> downloadMultipleImages(String userId, List<String> filenameList) async {
    // Create a reference to the Firebase Storage location of the image

    Reference test = FirebaseStorage.instance.ref();
    List<String> downloadUrlList = [];

    for(String filename in filenameList){
      String path = 'users/$userId/images/$filename';
      downloadUrlList.add(await test.child(path).getDownloadURL());
    }
    return downloadUrlList;
  }

  Future<List<images>> getImagesInFolder(String uid) async {
    Reference storageReference =
        FirebaseStorage.instance.ref("users/$uid/images");

    ListResult result = await storageReference.listAll();

    List<images> urlList = [];
    for (Reference ref in result.items) {
      // Get the download URL for each image
      String downloadUrl = await ref.getDownloadURL();
      String imageName = ref.name;
      urlList.add(images(downloadUrl, imageName));
    }
    return urlList;
  }

  Future<void> deleteImage(String userId, String downloadUrl) async {
    final url = 'http://10.0.2.2:5001/unify-ef8e0/us-central1/api/deleteImage';

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
        'http://10.0.2.2:5001/unify-ef8e0/us-central1/api/uploadProfilePicture';
    try {
      String base64Image = base64Encode(await image.readAsBytes());

      await http.post(
        Uri.parse(url),
        body: {
          'image': base64Image,
          'userId': _user!.id
        },
      ).then((value) => {
        updateUserProfilePicture(value.body.replaceAll('"', "")),
      });


    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUserProfilePicture(String fileName) async {

    const url =
        'http://10.0.2.2:5001/unify-ef8e0/us-central1/api/updateUserProfilePicture';
    try {
      String downloadUrl = await downloadImage(_user!.id, fileName);

      await http.put(
        Uri.parse(url),
        body: {
          'url': downloadUrl,
          'userId': _user!.id
        },
      );

    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadImages(List<XFile> images) async {
    const url =
        'http://10.0.2.2:5001/unify-ef8e0/us-central1/api/uploadImages';
    try {
      List<String> base64Images = [];
      for(XFile img in images){
        base64Images.add(base64Encode(await img.readAsBytes()));
      }

      Map<String, dynamic> map;
      await http.post(
        Uri.parse(url),
        body: {
          'images': base64Images.toString(),
          'userId': FirebaseAuth.instance.currentUser!.uid
        },
      ).then((value) => {
        updateUserImages(json.decode(value.body).cast<String>().toList()).then((value) => getUser())
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> updateUserImages(List<String> fileNames) async {
    const url =
        'http://10.0.2.2:5001/unify-ef8e0/us-central1/api/updateUserImages';
    try {
      List<String> downloadUrl = await downloadMultipleImages(_user!.id, fileNames);
      await http.put(
        Uri.parse(url),
        body: {
          'urls': downloadUrl.toString(),
          'userId': _user!.id
        },
      );

    } catch (e) {
      print(e);
    }

  }


}
