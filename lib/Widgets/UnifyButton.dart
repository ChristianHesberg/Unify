import 'package:flutter/material.dart';

class UnifyButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final Color? color;

  const UnifyButton(
      {Key? key, required this.onPressed, this.color, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          backgroundColor: color ?? const Color(0xff005fff)),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
