import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GenderCheckBoxes extends StatefulWidget {
  final bool men;
  final bool women;
  final bool other;
  final Function(Map<String, bool> valueMap) onClick;
   const GenderCheckBoxes(
      {Key? key, required this.men, required this.women, required this.other, required this.onClick, })
      : super(key: key);

  @override
  State<GenderCheckBoxes> createState() => _GenderCheckBoxesState();
}

class _GenderCheckBoxesState extends State<GenderCheckBoxes> {
  late final Map<String, bool> checkboxValues;

  @override
  void initState() {
    super.initState();
    checkboxValues = {"Men": widget.men, "Women": widget.women, "Other": widget.other};
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: checkboxValues.keys.map((String key) {
        return CheckboxListTile(
          title: Text(key),
          value: checkboxValues[key],
          onChanged: (value) {
            setState(() {
              checkboxValues[key] = value!;
              widget.onClick(checkboxValues);

            });
          },
        );
      }).toList(),
    );
  }
}
