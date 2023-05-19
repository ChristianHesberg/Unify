import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'appImage.dart';
import 'package:intl/intl.dart';

class AppUser{
  String id;
  String name;
  DateTime birthday;
  double lat;
  double lng;
  String gender;
  int maxAgePreference;
  int minAgePreference;
  List<String> genderPreferences;
  int locationPreference;
  String profilePicture;
  String description;
  List<AppImage> imageList;

  AppUser(
      this.id,
      this.name,
      this.birthday,
      this.lat,
      this.lng,
      this.gender,
      this.maxAgePreference,
      this.minAgePreference,
      this.genderPreferences,
      this.locationPreference,
      this.description,
      this.profilePicture,
      this.imageList);

  /*AppUser.fromMap(this.id, Map<String, dynamic> data)
    : name = data['name'],
      birthday = (data['birthday'] as Timestamp).toDate(),
      lat = data['lat'],
      lng = data['lng'],
      gender = data['gender'],
      maxAgePreference = data['maxAgePreference'],
      minAgePreference = data['minAgePreference'],
      genderPreferences = getGenderPreferencesAsList(data['malePreference'], data['femalePreference'], data['otherGenderPreference']),
      locationPreference = data['distancePreference'],
      description = data['description'],
      profilePicture = data['profilePicture'],
      imageList =



   */
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

  getGenderAsPreference(){
    switch(gender){
      case 'female':{return 'femalePreference';}
      case 'male':{return 'malePreference';}
      case 'other':{return 'otherPreference';}
    }
  }

  getGenderPreferencesAsString(){
    String prefs = '';
    for (var element in genderPreferences) {
      prefs += '$element-';
    }
    if (prefs.isNotEmpty) {
      prefs = prefs.substring(0, prefs.length - 1);
    }
    return prefs;
  }

  static getGenderPreferencesAsList(bool malePref, bool femalePref, bool otherPref) {
    List<String> prefs = [];
    if(malePref) prefs.add('male');
    if(femalePref) prefs.add('female');
    if(otherPref) prefs.add('other');
  }

  static getImageListFromData(){

  }
}