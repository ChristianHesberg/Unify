
import 'package:flutter/material.dart';

class UserTextField extends StatelessWidget {
  final bool? enabled;
  final String? initialText;
  final String? label;
  final TextEditingController controller;

   UserTextField({super.key, this.enabled, this.initialText,this.label, required this.controller});




  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration:  InputDecoration(
        labelText: label,
      ),
      enabled: enabled,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      initialValue: initialText,
      controller: controller,
      validator: (value) {
        if(value!.isEmpty){
          return "field is empty";
        }
      },
    );
  }
  
  
  
}