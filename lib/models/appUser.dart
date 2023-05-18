import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:intl/intl.dart';
class AppUser{
  String id;
  String name;
  DateTime birthday;
  late GeoFirePoint location;
  String gender;
  int maxAgePreference;
  int minAgePreference;
  List<String> genderPreferences;
  double locationPreference;
  String profilePicture;
  String description;

  AppUser(
      this.id,
      this.name,
      this.birthday,
      this.gender,
      this.maxAgePreference,
      this.minAgePreference,
      this.genderPreferences,
      this.locationPreference,
      this.profilePicture,
      this.description);

  getBirthdayAsAge(){
    var now = DateTime.now();
    return (now.difference(birthday).inDays/365).truncate();
  }

  getMaxAgePrefAsBirthday(){
    var ageDuration = Duration(days: maxAgePreference*365);
    return DateFormat.yMMMMd().format(DateTime.now().subtract(ageDuration));
  }

  getMinAgePrefAsBirthday(){
    var ageDuration = Duration(days: minAgePreference*365);
    return DateFormat.yMMMd().format(DateTime.now().subtract(ageDuration));
  }
}