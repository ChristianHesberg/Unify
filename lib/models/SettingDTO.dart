import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

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
  int locationPreference;
  XFile profilePicture;
  List<XFile> imageList;
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
      required this.imageList,
      required this.description});
}
