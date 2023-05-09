import 'package:geoflutterfire2/geoflutterfire2.dart';
class User{
  String id;
  String name;
  int age;
  late GeoFirePoint location;
  String gender;
  int maxAgePreference;
  int minAgePreference;
  List<String> genderPreferences;
  double locationPreference;

  User(
      this.id,
      this.name,
      this.age,
      this.gender,
      this.maxAgePreference,
      this.minAgePreference,
      this.genderPreferences,
      this.locationPreference);
}