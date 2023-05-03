import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Unify")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Login"),
            TextField(),
            TextField(),
            ElevatedButton(onPressed: () {}, child: Text("Login")),
            ElevatedButton(onPressed: () {}, child: Text("Register"))
          ],
        ),
      ),
    );
  }
}
