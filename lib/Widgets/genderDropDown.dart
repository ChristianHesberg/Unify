import 'package:flutter/material.dart';
class GenderDropDown extends StatefulWidget {
  GenderDropDown(
      {Key? key, required this.onSelect, this.startIndex, this.canChange})
      : super(key: key);
  final int? startIndex;
  final bool? canChange;
  final Function(String) onSelect;

  @override
  State<GenderDropDown> createState() => _GenderDropDownState();
}

class _GenderDropDownState extends State<GenderDropDown> {
  final optionMap = {"other": "Other", "man": "Man", "woman": "Woman"};


  late String dropdownValue = optionMap.keys.toList()[widget.startIndex ?? 0];


  @override
  void initState() {
    super.initState();
    widget.onSelect(optionMap.keys.toList()[0]);
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.canChange ?? false,
      child: DropdownButton(
          value: dropdownValue,
          items: optionMap.keys
              .map(
                (key) =>
                DropdownMenuItem<String>(
                  value: key,
                  child: Text(optionMap[key]!),
                ),
          )
              .toList(),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              widget.onSelect(value!);
              dropdownValue = value;
            });
          }),
    );
  }
}
