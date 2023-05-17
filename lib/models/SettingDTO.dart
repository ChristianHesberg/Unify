import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';

class SettingsDTO {
  final String id;
  String name;
  DateTime age;
  GeoFirePoint position;
  String gender;
  int maxAgePreference;
  int minAgePreference;
  bool femalePreference;
  bool malePreference;
  bool otherPreference;
  double locationPreference;
  String profilePicture;
  String description;

  SettingsDTO(
      {required this.id,
      required this.name,
      required this.age,
      required this.position,
      required this.gender,
      required this.maxAgePreference,
      required this.minAgePreference,
      required this.femalePreference,
      required this.malePreference,
      required this.otherPreference,
      required this.locationPreference,
      required this.profilePicture,
      required this.description});
}
