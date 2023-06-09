import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCSQVVMOL7rFYmOygrPelfpVDDIhLrbhI0',
    appId: '1:809845493582:web:7a4e562199a87b2695581f',
    messagingSenderId: '809845493582',
    projectId: 'unify-ef8e0',
    authDomain: 'unify-ef8e0.firebaseapp.com',
    storageBucket: 'unify-ef8e0.appspot.com',
    measurementId: 'G-Y65R191PBB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBnYFPa6ArX8qHinPiptd2ZZQoHyA875gs',
    appId: '1:809845493582:android:28795b54cba9c91c95581f',
    messagingSenderId: '809845493582',
    projectId: 'unify-ef8e0',
    storageBucket: 'unify-ef8e0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDB3BNupNH8KreV3FMRNtSB9Rpqo5dZKBw',
    appId: '1:809845493582:ios:8f5e9cba479d711195581f',
    messagingSenderId: '809845493582',
    projectId: 'unify-ef8e0',
    storageBucket: 'unify-ef8e0.appspot.com',
    iosClientId: '809845493582-raubqvous5k9pa41vlepqt5dr6j146mp.apps.googleusercontent.com',
    iosBundleId: 'com.example.unify',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDB3BNupNH8KreV3FMRNtSB9Rpqo5dZKBw',
    appId: '1:809845493582:ios:8f5e9cba479d711195581f',
    messagingSenderId: '809845493582',
    projectId: 'unify-ef8e0',
    storageBucket: 'unify-ef8e0.appspot.com',
    iosClientId: '809845493582-raubqvous5k9pa41vlepqt5dr6j146mp.apps.googleusercontent.com',
    iosBundleId: 'com.example.unify',
  );
}
