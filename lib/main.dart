import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unify/user_service.dart';

import 'Screens/NavigatorScreen.dart';
import 'package:provider/provider.dart';
import 'package:unify/Screens/LoginScreen.dart';
import 'package:unify/Screens/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unify/firebase_options.dart';
import 'package:unify/match_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MatchService service = MatchService();
    //service.writeLocation();
    //service.getUsersWithinRadius();
    return MultiProvider(
        providers: [
          Provider(create: (context) => UserService(),),
          StreamProvider(
            create: (context) => FirebaseAuth.instance.authStateChanges(),
            initialData: null,
          )
        ],
        builder: (context, child) {
          final user = Provider.of<User?>(context);
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
