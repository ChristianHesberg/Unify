import 'package:flutter/material.dart';

class UnifyTextField extends StatelessWidget {
  final IconData? iconData;
  final TextInputType? keyboardType;
  final String? hintText;
  bool? obscureText = false;
  final TextEditingController controller;
  final String? Function(String?)? validator;

   UnifyTextField(
      {Key? key,
      this.iconData,
      this.hintText,
      required this.controller,
      this.validator, this.obscureText = false, this.keyboardType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText!,
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFEAEEF5),
        // contentPadding: ,
        prefixIcon: Icon(iconData),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0XFF9BA0AB),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
