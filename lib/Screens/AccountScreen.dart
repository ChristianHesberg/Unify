import 'package:flutter/material.dart';

import '../Widgets/user_text_field.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Info"),
        backgroundColor: Colors.black,

      ),
      body: _accountScreen(),
    );
  }

  bool canEdit = true;
  String name = "";
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();


  Widget _accountScreen() {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Column(
        children: [
          Form(
              key: _formKey,
              child: Column(children: [
                UserTextField(
                  controller: nameController,
                  label: "name",
                )
              ])),
          ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {});
                }
              },
              child: Text(nameController.text)),
        ],
      ),
    );
  }
}
