import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unify/user_service.dart';
import 'models/appImage.dart';
import 'Screens/NavigatorScreen.dart';
import 'package:provider/provider.dart';
import 'package:unify/Screens/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unify/firebase_options.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'chat_service.dart';
import 'models/appUser.dart';





Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAuth.instance.useAuthEmulator('10.0.2.2', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('10.0.2.2', 8080);
  FirebaseStorage.instance.useStorageEmulator('10.0.2.2', 9199);
  runApp(ChangeNotifierProvider(create: (context) => UserService(),child: MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(create: (context) => ChatService()),
          StreamProvider(
            create: (context) => FirebaseAuth.instance.authStateChanges(),
            initialData: null,
          )
        ],
        builder: (context, child) {
          final user = Provider.of<User?>(context);
          //final userService = Provider.of<UserService>(context);
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
