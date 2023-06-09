import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:unify/Screens/AccountScreen.dart';
import 'package:unify/Screens/ImageScreen.dart';
import 'package:unify/Screens/PreferenceScreen.dart';
import 'package:unify/user_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var userService = Provider.of<UserService>(context);
    return SettingsList(sections: [
      SettingsSection(title: const Text("Account"), tiles: <SettingsTile>[
        SettingsTile.navigation(
          leading: const Icon(Icons.account_circle),
          title: const Text("Account info"),
          trailing: const Icon(Icons.arrow_forward_ios),
          onPressed: (context) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AccountScreen(),
            ));
          },
        ),
        SettingsTile.navigation(
          leading: const Icon(Icons.supervisor_account_rounded),
          title: const Text("Search preferences"),
          trailing: const Icon(Icons.arrow_forward_ios),
          onPressed: (context) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PreferenceScreen(),
            ));
          },
        ),
        SettingsTile.navigation(
          leading: const Icon(Icons.image),
          title: const Text("Images"),
          trailing: const Icon(Icons.arrow_forward_ios),
          onPressed: (context) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ImageScreen(),
            ));
          },
        ),
      ]),
      SettingsSection(title: const Text("Logout"), tiles: <SettingsTile>[
        SettingsTile.navigation(
          leading: const Icon(Icons.logout),
          title: const Text("Logout"),
          onPressed: (context) {
            userService.signOut(context);
          },
        ),
      ])
    ]);
  }
}
