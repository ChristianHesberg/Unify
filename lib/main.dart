import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unify/FireService.dart';

import 'Screens/NavigatorScreen.dart';
import 'package:provider/provider.dart';
import 'package:unify/Screens/LoginScreen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unify/firebase_options.dart';
import 'package:unify/match_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //use emulator
  _connectToFirebaseEmulator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider(
            create: (context) => FirebaseAuth.instance.authStateChanges(),
            initialData: null,
          ),
          Provider<FireService>(create: (context) => FireService()),
        ],
        builder: (context, child) {
          var user = Provider.of<User?>(context);
          return MaterialApp(
            title: 'Just friends',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: user == null ? LoginScreen() : NavigatorScreen(),
          );
        });
  }
}

Future _connectToFirebaseEmulator() async {
  FirebaseFirestore.instance
      .useFirestoreEmulator("10.0.2.2", 8080, sslEnabled: false);
  FirebaseAuth.instance.useAuthEmulator("10.0.2.2", 9099);

}
