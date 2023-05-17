import 'dart:math';

import 'package:email_validator/email_validator.dart';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:unify/FireService.dart';
import 'package:unify/Screens/NavigatorScreen.dart';

import '../../Widgets/AgeSlider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _email =
      TextEditingController(text: "${Random().nextInt(10000)}@gmail.dk");
  final _password = TextEditingController(text: "123456");
  final _passwordAgain = TextEditingController(text: "123456");
  final _loginForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var fireService = Provider.of<FireService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register a new account"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
          child: Form(
            key: _loginForm,
            child: Column(
              children: [
                const Text("Create your login!"),
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
                  onPressed: () async {
                    if (_loginForm.currentState!.validate()) {
                      await fireService.createAccount(
                          _email.text, _password.text);

                      await fireService.signIn(_email.text, _password.text);

                      setState(() {
                        Navigator.of(context).pop();
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
