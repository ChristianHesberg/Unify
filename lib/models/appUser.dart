import 'package:geoflutterfire2/geoflutterfire2.dart';

class AppUser {
  final String id;
  String name;
  DateTime age;
  GeoFirePoint? location;
  String gender;
  int maxAgePreference;
  int minAgePreference;
  List<String> genderPreferences;
  double locationPreference;
  String profilePicture;
  String description;

  AppUser(
      {required this.id,
      required this.name,
      required this.age,
      this.location,
      required this.gender,
      required this.maxAgePreference,
      required this.minAgePreference,
      required this.genderPreferences,
      required this.locationPreference,
      required this.profilePicture,
      required this.description});

  @override
  String toString() {
    return 'AppUser{id: $id, name: $name, age: $age, location: $location, gender: $gender, maxAgePreference: $maxAgePreference, minAgePreference: $minAgePreference, genderPreferences: $genderPreferences, locationPreference: $locationPreference, profilePicture: $profilePicture, description: $description}';
  }
}
