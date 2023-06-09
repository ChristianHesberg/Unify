import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unify/Screens/ContactScreen.dart';
import 'package:unify/Screens/DiscoverScreen.dart';
import 'package:unify/Screens/registration/AccountSetupScreen.dart';
import 'package:unify/user_service.dart';
import 'SettingsScreen.dart';

class NavigatorScreen extends StatefulWidget {
  final int? startingPosition;

  NavigatorScreen({Key? key, this.startingPosition}) : super(key: key);

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.startingPosition ?? 0;
  }

  _showWidget(int pos) {
    switch (pos) {
      case 0:
        return Center(child: Container(width: 500,child: new DiscoverScreen()));
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
    var userService = Provider.of<UserService>(context);
    //future builder check status
    return FutureBuilder(
      future: userService.checkStatus(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == false) return const AccountSetupScreen();
          return _buildNavigatorScreen();
        }
        return _buildLoadingIndicator();
      },
    );
  }

  _buildNavigatorScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text("The FriendZone"), backgroundColor: Colors.black),
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

  _buildLoadingIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
