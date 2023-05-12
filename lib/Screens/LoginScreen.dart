import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
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

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final _fireService = Provider.of<FireService>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Unify")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Login"),
            TextField(controller: _email),
            TextField(
              controller: _password,
            ),
            _buildLoginBtn(_fireService),
            _buildRegisterBtn(),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterBtn() {
    return ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const RegisterScreen()));
        },
        child: Text("Register"));
  }

  Widget _buildLoginBtn(FireService fireService) {
    return ElevatedButton(
      onPressed: () async {
        final email = _email.value.text;
        final password = _password.value.text;
        fireService.signIn(email,password);
      },
      child: Text("Login"),
    );
  }
}
