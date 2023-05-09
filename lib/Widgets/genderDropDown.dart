import 'package:flutter/material.dart';

class GenderDropDown extends StatefulWidget {
  const GenderDropDown({Key? key}) : super(key: key);

  @override
  State<GenderDropDown> createState() => _GenderDropDownState();
}

class _GenderDropDownState extends State<GenderDropDown> {
  final optionMap = {"other": "Other", "man": "Man", "woman": "Woman"};

  late String dropdownValue = optionMap.keys.toList()[0];

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        value: dropdownValue,
        items: optionMap.keys
            .map(
              (key) => DropdownMenuItem<String>(
                value: key,
                child: Text(optionMap[key]!),
              ),
            )
            .toList(),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
          });
        });
  }
}
