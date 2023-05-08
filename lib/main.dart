import 'package:flutter/material.dart';
import 'package:unify/Screens/DiscoverScreen.dart';
import 'package:unify/Screens/StartScreen.dart';

import 'Screens/NavigatorScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Just friends',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NavigatorScreen(), //TODO change to const StartScreen();
    );
  }
}
