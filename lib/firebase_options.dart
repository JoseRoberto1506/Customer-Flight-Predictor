// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBHsWmrdZ9glyUrH3ZqnEsv1uVc5FO5plQ',
    appId: '1:681565083194:web:988d28b03e15c3b73cc703',
    messagingSenderId: '681565083194',
    projectId: 'cfpdsiapp',
    authDomain: 'cfpdsiapp.firebaseapp.com',
    databaseURL: 'https://cfpdsiapp-default-rtdb.firebaseio.com',
    storageBucket: 'cfpdsiapp.appspot.com',
    measurementId: 'G-SD6G60X24W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCYoVUtQNCemVu0sqmrXS2WLcm5LB9QBlE',
    appId: '1:681565083194:android:9dbd889b769c222f3cc703',
    messagingSenderId: '681565083194',
    projectId: 'cfpdsiapp',
    databaseURL: 'https://cfpdsiapp-default-rtdb.firebaseio.com',
    storageBucket: 'cfpdsiapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAcVJUvtUMiF6cHUkL3yDaCyVThesI1Ndg',
    appId: '1:681565083194:ios:3c244cd7bbbd67313cc703',
    messagingSenderId: '681565083194',
    projectId: 'cfpdsiapp',
    databaseURL: 'https://cfpdsiapp-default-rtdb.firebaseio.com',
    storageBucket: 'cfpdsiapp.appspot.com',
    iosClientId: '681565083194-bftfpme11phdmh87p7ertn824hp1dabt.apps.googleusercontent.com',
    iosBundleId: 'com.example.cfpApp',
  );
}
