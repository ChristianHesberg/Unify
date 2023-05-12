import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:unify/Widgets/AgeSlider.dart';
import 'package:unify/Widgets/DistanceSlider.dart';
import 'package:unify/Widgets/GenderCheckBoxes.dart';

class PreferenceScreen extends StatefulWidget {
  const PreferenceScreen({Key? key}) : super(key: key);

  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Preferences"),backgroundColor: Colors.black),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              GenderCheckBoxes(men: true, women: false, other: true, onClick: _handleGenderCheckBoxes),

              AgeSlider(ageRangeValues: rangeValues, onSlide: _handleOnSlide),

              DistanceSlider(onSlide: _handleDistanceSlider,startingValue: distance,),

              ElevatedButton(onPressed: () {}, child: Text("Update"))
            ],
          ),
        ),
      ),
    );
  }

  double distance = 1;
  _handleDistanceSlider(double val) {
    distance = val;
  }

  Map<String, bool> genderMap = {};
  _handleGenderCheckBoxes(Map<String, bool> values) {
    genderMap = values;
  }

  var rangeValues = const SfRangeValues(18, 75);
  _handleOnSlide(SfRangeValues values) {
    rangeValues = values;
    //husk at round
  }
}
