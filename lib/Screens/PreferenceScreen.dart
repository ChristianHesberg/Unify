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
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preferences"), backgroundColor: Colors.black),
      body: !loading ? Consumer<UserService>(
        builder: (context, value, child) {
          if (value.user == null) {
            value.getUser();
            return const Center(child: CircularProgressIndicator());
          } else {
            this.user = value.user!;
            return _buildView();
          }
        },
      ) : const Center(child: CircularProgressIndicator(),),
    );
  }


  SingleChildScrollView _buildView() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
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
                        setState(() {loading = true;});
                        final userService =
                            Provider.of<UserService>(context, listen: false);
                        await userService.updateUserPreference(
                            rangeValues?.start.toInt() ?? user.minAgePreference,
                            rangeValues?.end.toInt() ?? user.maxAgePreference,
                            genderMap["Women"] ??
                                user.genderPreferences.contains("female"),
                            genderMap["Men"] ??
                                user.genderPreferences.contains("male"),
                            genderMap["Other"] ??
                                user.genderPreferences.contains("other"),
                            distance?.round() ?? user.locationPreference).then((value) {
                              setState(() {loading = false;});
                            },);
                      },
                      child: Text("Update"))
                ],
              )
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
