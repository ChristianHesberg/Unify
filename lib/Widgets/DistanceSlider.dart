import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class DistanceSlider extends StatefulWidget {
  final Function(double value) onSlide;
  double startingValue;

  DistanceSlider({Key? key, required this.onSlide, this.startingValue = 50})
      : super(key: key);

  @override
  State<DistanceSlider> createState() => _DistanceSliderState();
}

class _DistanceSliderState extends State<DistanceSlider> {
  final double min = 1;
  final double max = 100;
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.startingValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Find people within ${_value.round()} Km", style: Theme.of(context).textTheme.headlineSmall,),
        SfSlider(
            value: _value,
            min: min,
            max: max,
            showLabels: true,
            onChanged: (val) {
              setState(() {
                widget.onSlide(val);
                _value = val;
              });
            }),
      ],
    );
  }
}
