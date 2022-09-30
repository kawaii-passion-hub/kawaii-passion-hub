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
class AuthFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyABcWQDZSsBe7UZSKBLbc23Xsqf3JWJtuc',
    appId: '1:958812987232:web:fa5572c2b8f8a5c8354805',
    messagingSenderId: '958812987232',
    projectId: 'kawaii-passion-hub-auth',
    authDomain: 'kawaii-passion-hub-auth.firebaseapp.com',
    databaseURL:
        'https://kawaii-passion-hub-auth-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'kawaii-passion-hub-auth.appspot.com',
    measurementId: 'G-W04N1EB6TC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCttki_Tvdkpxv5KIazc5ZCXRtuleaNUSg',
    appId: '1:958812987232:android:577184ea66b8835a354805',
    messagingSenderId: '958812987232',
    projectId: 'kawaii-passion-hub-auth',
    databaseURL:
        'https://kawaii-passion-hub-auth-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'kawaii-passion-hub-auth.appspot.com',
  );
}
