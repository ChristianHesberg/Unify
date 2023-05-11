import 'package:flutter/material.dart';
import 'package:unify/Widgets/genderDropDown.dart';
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

  bool canEdit = false;
  String name = "";
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

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
                      onPressed: () {
                        canEdit = true;
                        setState(() {
                        });
                      },
                      child: const Icon(Icons.edit),
                    )),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Text("Ole"),
                )
              ],
            ),
          ),
        _userInfoForm(),
          _submitBtn(),
        ],
      ),
    );
  }

  Widget _userInfoForm() {
    return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(children: [
                UserTextField(
                  controller: nameController..text = "sofie",
                  label: "name",
                  enabled: canEdit,
                ),
                UserTextField(
                  controller: descController..text = "It takes a great deal of bravery to stand up to our enemies, but just as much to stand up to our friends.",
                  label: "desc",
                  enabled: canEdit,
                ),
                _genderDropDown(),

              ]),
            ));
  }

  Widget _genderDropDown() {
    return Placeholder();//GenderDropDown(startIndex: 1,canChange: !canEdit,);
  }

  Widget _submitBtn() {
    if(canEdit){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
              ElevatedButton(
              onPressed: () {},
              child: const Text("Submit")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                canEdit = false;
                setState(() {
                });
              },
              child: const Text("Cancel")),
        ],
      );
    }else{
      return Container();
    }
    }
}
