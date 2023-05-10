import 'package:flutter/material.dart';
import 'package:unify/Widgets/user_text.dart';

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
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 300,
            width: 200,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100), // Image border
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(120), // Image radius
                      child: Image.network(
                          'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 25,
                    right: 10,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(300.0),
                          ),
                        ),
                      ),
                      onPressed: () {},
                      child: const Icon(Icons.edit),
                    )),
              ],
            ),
          ),
          Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(children: [
                  UserTextField(
                    controller: nameController,
                    label: "name",
                  )
                ]),
              )),
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
