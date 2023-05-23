import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  final Function(DateTime) onClick;
  DateTime? birthDate;

  DatePicker({Key? key, required this.onClick, this.birthDate})
      : super(key: key);

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    return _createDateBtn();
  }

  Widget _createDateBtn() {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
            onPressed: () {
              final today = DateTime.now();
              final minusEightTeen =
                  DateTime(today.year - 18, today.month, today.day);
              showDatePicker(
                      context: context,
                      initialDate: minusEightTeen,
                      firstDate: DateTime(1900),
                      lastDate: minusEightTeen)
                  .then((value) {
                if (value == null) return;
                setState(() {
                  widget.birthDate = value;
                  widget.onClick(value);
                });
              });
            },
            child: const Text("Select birthday")),
        widget.birthDate == null
            ? Text("Pick your birthday!")
            : Text(formatter.format(widget.birthDate!))
      ],
    );
  }
}
