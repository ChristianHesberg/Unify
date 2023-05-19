import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unify/FireService.dart';
import 'package:provider/provider.dart';
import 'package:unify/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unify/firebase_options.dart';
import 'package:unify/match_service.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'Screens/LoginScreen.dart';
import 'Screens/NavigatorScreen.dart';
import 'chat_service.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  //use emulator
  _connectToFirebaseEmulator();

  runApp(const MyApp());
  FirebaseAuth.instance.useAuthEmulator('10.0.2.2', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
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
              home: user == null ? const LoginScreen() : const NavigatorScreen()
          );
        });
  }
}


Future _connectToFirebaseEmulator() async {
  FirebaseFirestore.instance
      .useFirestoreEmulator("10.0.2.2", 8080, sslEnabled: false);
  FirebaseAuth.instance.useAuthEmulator("10.0.2.2", 9099);
}
