import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AppUser {
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
  List<dynamic> imageList;
  List<dynamic> blacklist;

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
      this.imageList,
      this.blacklist);


  AppUser.fromMapJson(this.id, Map<String, dynamic> data)
    : name = data['name'],
      birthday = Timestamp(data['birthday']['_seconds'], data['birthday']['_nanoseconds']).toDate(),
      lat = data['lat'],
      lng = data['lng'],
      gender = data['gender'],
      maxAgePreference = data['maxAgePreference'],
      minAgePreference = data['minAgePreference'],
      genderPreferences = getGenderPreferencesAsList(data['malePreference'], data['femalePreference'], data['otherGenderPreference']),
      locationPreference = data['distancePreference'],
      description = data['description'],
      profilePicture = data['profilePicture'],
      imageList = data['imageList'],
      blacklist = data['blacklist'];

  AppUser.fromMap(this.id, Map<String, dynamic> data)
      : name = data['name'],
        birthday = data['birthday'].toDate(),
        lat = data['lat'],
        lng = data['lng'],
        gender = data['gender'],
        maxAgePreference = data['maxAgePreference'],
        minAgePreference = data['minAgePreference'],
        genderPreferences = getGenderPreferencesAsList(data['malePreference'], data['femalePreference'], data['otherGenderPreference']),
        locationPreference = data['distancePreference'],
        description = data['description'],
        profilePicture = data['profilePicture'],
        imageList = data['imageList'],
        blacklist = data['blacklist'];


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
    return prefs;
  }

  static getImageListFromData(){

  }

  @override
  String toString() {
    return 'AppUser{id: $id, name: $name, birthday: $birthday, lat: $lat, lng: $lng, gender: $gender, maxAgePreference: $maxAgePreference, minAgePreference: $minAgePreference, genderPreferences: $genderPreferences, locationPreference: $locationPreference, profilePicture: $profilePicture, description: $description, imageList: $imageList}';
  }
}

