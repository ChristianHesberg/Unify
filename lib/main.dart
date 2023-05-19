import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unify/Models/appImage.dart';
import 'package:unify/user_service.dart';
import 'Models/appImage.dart';
import 'Screens/NavigatorScreen.dart';
import 'package:provider/provider.dart';
import 'package:unify/Screens/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unify/firebase_options.dart';
import 'package:unify/match_service.dart';
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
  
  MatchService matchService = MatchService();
  AppUser user = AppUser('B2ZugXQqCmy7tp2wamPx', 'crissy', DateTime(1998, 1, 1), 37.3882733, -122.0778017, 'female', 40, 20, ['male', 'female', 'other'], 40, 'string', 'description', [AppImage('string','string')]);
  matchService.getUsersWithinRadius(user);
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
