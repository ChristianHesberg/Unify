import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:unify/models/appUser.dart';
import 'package:unify/Widgets/AgeSlider.dart';
import 'package:unify/Widgets/DistanceSlider.dart';
import 'package:unify/Widgets/GenderCheckBoxes.dart';

import '../user_service.dart';

class PreferenceScreen extends StatefulWidget {
  const PreferenceScreen({Key? key}) : super(key: key);

  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  late AppUser user;
  double? distance;
  Map<String, bool> genderMap = {};
  SfRangeValues? rangeValues;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Preferences"), backgroundColor: Colors.black),
      body: Consumer<UserService>(
        builder: (context, value, child) {
          if (value.user == null) {
            value.getUser();
            return Center(child: CircularProgressIndicator());
          } else {
            this.user = value.user!;
            return _buildView();
          }
        },
      ),
    );
  }

  bool loading = false;

  SingleChildScrollView _buildView() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: loading == false
            ? Column(
                children: [
                  GenderCheckBoxes(
                      men: user.genderPreferences.contains("male"),
                      women: user.genderPreferences.contains("female"),
                      other: user.genderPreferences.contains("other"),
                      onClick: _handleGenderCheckBoxes),
                  AgeSlider(
                      ageRangeValues: SfRangeValues(
                          user.minAgePreference, user.maxAgePreference),
                      onSlide: _handleOnSlide),
                  DistanceSlider(
                    onSlide: _handleDistanceSlider,
                    startingValue: user.locationPreference.toDouble(),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        loading = true;
                        final userService =
                            Provider.of<UserService>(context, listen: false);
                        await userService.updateUserPreference(
                            rangeValues?.start ?? user.minAgePreference,
                            rangeValues?.end ?? user.maxAgePreference,
                            genderMap["Woman"] ??
                                user.genderPreferences.contains("female"),
                            genderMap["Man"] ??
                                user.genderPreferences.contains("male"),
                            genderMap["Other"] ??
                                user.genderPreferences.contains("other"),
                            distance?.round() ?? user.locationPreference);
                        loading = false;
                        setState(() {});
                      },
                      child: Text("Update"))
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }

  _handleDistanceSlider(double val) {
    distance = val;
  }

  _handleGenderCheckBoxes(Map<String, bool> values) {
    genderMap = values;
  }

  _handleOnSlide(SfRangeValues values) {
    rangeValues = values;
    //husk at round
  }
}
