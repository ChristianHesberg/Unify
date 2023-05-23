import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:unify/Screens/NavigatorScreen.dart';
import 'package:unify/Screens/registration/RegisterScreen.dart';

import '../FireService.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final fireService = Provider.of<FireService>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Unify")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Login",style: Theme.of(context).textTheme.headlineLarge,),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: "Email"),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains("@")) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _password,
                    decoration: const InputDecoration(labelText: "Password"),
                    obscureText: true,
                    validator: (value) {
                      if (value!.length < 6) {
                        return "Wrong password";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            _buildLoginBtn(fireService),
            _buildRegisterBtn(),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterBtn() {
    return ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RegisterScreen()));
        },
        child: const Text("Register"));
  }

  Widget _buildLoginBtn(FireService fireService) {
    return ElevatedButton(
      onPressed: () async {
        if (!_formKey.currentState!.validate()) {
          setState(() {});
          return;
        }
        final email = _email.value.text;
        final password = _password.value.text;
        try {
          await fireService.signIn(email, password);

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => NavigatorScreen(),
            ),
          );
        } catch (e) {
          _showSnackBar(context);
        }
      },
      child: Text("Login"),
    );
  }

  _showSnackBar(context) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No user with that login info exists!")));
  }
}
