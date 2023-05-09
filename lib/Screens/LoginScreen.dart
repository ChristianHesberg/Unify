import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
            _buildLoginBtn(),
            ElevatedButton(onPressed: () {}, child: Text("Register"))
          ],
        ),
      ),
    );
  }



  Widget _buildLoginBtn() {
    return ElevatedButton(
      onPressed: () async {
        final email = _email.value.text;
        final password = _password.value.text;
        _auth.signInWithEmailAndPassword(email: email, password: password);
        print("Login success");
      },
      child: Text("Login"),
    );
  }
}