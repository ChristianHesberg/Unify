import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class AgeSlider extends StatefulWidget {
  SfRangeValues ageRangeValues;
  final Function(SfRangeValues) onSlide;

  AgeSlider({Key? key, required this.ageRangeValues, required this.onSlide})
      : super(key: key);

  @override
  State<AgeSlider> createState() => _AgeSliderState();
}

class _AgeSliderState extends State<AgeSlider> {
  @override
  Widget build(BuildContext context) {
    double max = 100;
    double min = 18;
    return Column(children: [
      SfRangeSlider(
          max: max,
          min: min,
          showLabels: true,
          values: widget.ageRangeValues,
          onChanged: (values) {
            setState(() {
              widget.ageRangeValues = values;
              widget.onSlide(values);
            });
          }),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Min: ${widget.ageRangeValues.start.round()}",
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            "Min: ${widget.ageRangeValues.end.round()}",
            style: const TextStyle(fontSize: 18),
          )
        ],
      ),
    ]);
  }
}
