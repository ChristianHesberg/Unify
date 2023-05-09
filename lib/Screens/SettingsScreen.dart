import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unify/Widgets/user_text.dart';

import '../Widgets/user_text_field.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool canEdit = true;
  String name = "";
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Column(
        children: [
          Form(
            key: _formKey,
              child: Column(children: [
                UserTextField(controller: nameController,label: "name",)

              ])),

          ElevatedButton(onPressed: () {
            if(_formKey.currentState!.validate()){
              setState(() {});
            }

          }, child: Text(nameController.text)),
          ElevatedButton(onPressed: () {
            FirebaseAuth.instance.signOut();
          }, child: Text("logout"), style: ElevatedButton.styleFrom(primary: Colors.red),)

        ],
      ),
    );
  }
}
