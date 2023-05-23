import 'package:flutter/material.dart';

class UnifyTextField extends StatelessWidget {
  final IconData? iconData;
  final TextInputType? keyboardType;
  final String? hintText;
  bool? obscureText = false;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int? maxLines;

   UnifyTextField(
      {Key? key,
      this.iconData,
      this.hintText,
      required this.controller,
      this.validator, this.obscureText = false, this.keyboardType, this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        maxLines: maxLines ?? 1,
        keyboardType: keyboardType,
        validator: validator,
        obscureText: obscureText!,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFEAEEF5),
          // contentPadding: ,
          prefixIcon: iconData != null ? Icon(iconData) : null,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0XFF9BA0AB),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
