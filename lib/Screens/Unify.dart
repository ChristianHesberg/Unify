import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import 'LoginScreen.dart';
import 'NavigatorScreen.dart';

class UnifyScreen extends StatelessWidget {
  const UnifyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return user == null ? LoginScreen() : NavigatorScreen();
  }
}
