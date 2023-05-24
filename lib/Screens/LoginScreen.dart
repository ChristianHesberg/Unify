import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:unify/Screens/NavigatorScreen.dart';
import 'package:unify/Screens/registration/RegisterScreen.dart';
import 'package:unify/user_service.dart';

import '../Widgets/UnifyButton.dart';
import '../Widgets/UnifyTextField.dart';

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
    final fireService = Provider.of<UserService>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Enter The FriendZone",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 75,
            ),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildEmailInput(),

                  _buildPasswordInput(),
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

  UnifyTextField _buildPasswordInput() {
    return UnifyTextField(
      iconData: Icons.key,
      controller: _password,
      hintText: "Password",
      obscureText: true,
      validator: (value) {
        if (value!.length < 6) {
          return "Wrong password";
        }
        return null;
      },
    );
  }

  UnifyTextField _buildEmailInput() {
    return UnifyTextField(
      iconData: Icons.email,
      hintText: "Example@email.com",
      keyboardType: TextInputType.emailAddress,
      controller: _email,
      validator: (value) {
        if (value!.isEmpty || !value.contains("@")) {
          return "Enter a valid email";
        }
        return null;
      },
    );
  }

  Widget _buildRegisterBtn() {
    return UnifyButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RegisterScreen()));
        },
        text: "Register");
  }

  Widget _buildLoginBtn(UserService userService) {
    return UnifyButton(
      onPressed: () async {
        if (!_formKey.currentState!.validate()) {
          setState(() {});
          return;
        }
        final email = _email.value.text;
        final password = _password.value.text;
        try {
          await userService.signIn(email, password);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => NavigatorScreen(),
            ),
          );
        } catch (e) {
          _showSnackBar(context);
        }
      },
      text: "Login",
    );
  }

  _showSnackBar(context) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No user with that login info exists!")));
  }
}
