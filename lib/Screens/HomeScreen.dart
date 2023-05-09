import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unify/Screens/LoginScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Welcome")),
      body: Column(children: [
        Text(
          "${user?.email}",
          style: TextStyle(fontSize: 40),
        ),
        ElevatedButton(onPressed: () {
          FirebaseAuth.instance.signOut();
        }, child: Text("logout"))
      ]),
    );
  }
}
