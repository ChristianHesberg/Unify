import 'dart:math';

import 'package:cross_file_image/cross_file_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:unify/FireService.dart';
import 'package:unify/Screens/NavigatorScreen.dart';
import 'package:unify/Screens/Unify.dart';
import 'package:unify/Widgets/DatePicker.dart';
import 'package:unify/Widgets/DistanceSlider.dart';
import 'package:unify/Widgets/GenderCheckBoxes.dart';
import 'package:unify/Widgets/ImageScroll.dart';
import 'package:unify/Widgets/genderDropDown.dart';

import '../../Widgets/AgeSlider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController(text: "asdasdasd");

  final _email =
      TextEditingController(text: "${Random().nextInt(10000)}@gmail.dk");
  final _password = TextEditingController(text: "123456");
  final _passwordAgain = TextEditingController(text: "123456");
  final _loginForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var fireService = Provider.of<FireService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Register a new account")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
          child: Form(
            key: _loginForm,
            child: Column(
              children: [
                const Text("Create your login!"),
                TextFormField(
                  decoration: const InputDecoration(
                      label: Text("Name"), hintText: "Your name"),
                  controller: _name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Input your name";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _email,
                  validator: (value) {
                    if (value == null || !EmailValidator.validate(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      labelText: "Email", hintText: "Example@Email.com"),
                ),
                const Padding(padding: EdgeInsets.only(top: 30)),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Password"),
                ),
                TextFormField(
                  controller: _passwordAgain,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: "Repeat password"),
                  validator: (value) {
                    if (value == null ||
                        _password.text != _passwordAgain.text ||
                        _passwordAgain.text.length < 6) {
                      return 'Your password must match and be 6 characters long';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_loginForm.currentState!.validate()) {
                      fireService.createAccount(
                          _name.text, _email.text, _password.text);

                      fireService.signIn(_email.text, _password.text);

                      setState(() {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const NavigatorScreen(),
                          ),
                        );
                      });
                    } else {}
                  },
                  child: const Text("Create account!"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
