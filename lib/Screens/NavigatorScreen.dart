import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unify/FireService.dart';
import 'package:unify/Screens/ContactScreen.dart';
import 'package:unify/Screens/DiscoverScreen.dart';
import 'package:unify/Screens/registration/AccountSetupScreen.dart';

import 'SettingsScreen.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({Key? key}) : super(key: key);

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    //TODO HOW OMG
    //get user info
    // check if account is set up ->
    //if not -> setup screen
    //else find matches -> nav screen
  }

  _showWidget(int pos) {
    switch (pos) {
      case 0:
        return new DiscoverScreen();
      case 1:
        return new ContactScreen();
      case 2:
        return new SettingsScreen();
      default:
        return new Text("Error");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Unify"), backgroundColor: Colors.black),
      body: _showWidget(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                label: "Discover", icon: Icon(Icons.people)),
            BottomNavigationBarItem(label: "Chat", icon: Icon(Icons.chat)),
            BottomNavigationBarItem(
                label: "Settings", icon: Icon(Icons.settings)),
          ]),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
