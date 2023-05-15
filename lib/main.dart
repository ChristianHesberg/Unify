import 'package:flutter/material.dart';
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
