import 'dart:math';

import 'package:email_validator/email_validator.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:unify/Screens/NavigatorScreen.dart';
import 'package:unify/Widgets/UnifyButton.dart';
import 'package:unify/Widgets/UnifyTextField.dart';
import 'package:unify/user_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _passwordAgain = TextEditingController();
  final _loginForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var userService = Provider.of<UserService>(context);

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
                Text(
                  "Create your login!",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Padding(padding: EdgeInsets.only(top: 30)),
                UnifyTextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _email,
                  validator: (value) {
                    if (value == null || !EmailValidator.validate(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                  hintText: "Example@Email.com",
                  iconData: Icons.email,
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                UnifyTextField(
                  controller: _password,
                  obscureText: true,
                  hintText: "Password",
                  iconData: Icons.password,
                ),

                UnifyTextField(
                  controller: _passwordAgain,
                  obscureText: true,
                  hintText: "Repeat Password",
                  iconData: Icons.password,
                  validator: (value) {
                    if (value == null ||
                        _password.text != _passwordAgain.text ||
                        _passwordAgain.text.length < 6) {
                      return 'Your password must match and be 6 characters long';
                    }
                    return null;
                  },
                ),
                UnifyButton(
                  onPressed: () async {
                    if (_loginForm.currentState!.validate()) {
                      await userService.createAccount(
                          _email.text, _password.text);

                      await userService.signIn(_email.text, _password.text);

                      setState(() {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => NavigatorScreen(),
                          ),
                        );
                      });
                    } else {}
                  },
                  text: "Create account!",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
