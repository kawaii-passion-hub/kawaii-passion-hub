import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kawaii_passion_hub/auth_gate.dart';
import 'firebase_options.dart';
import 'loading_page.dart';

const bool _useEmulator = true;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<void> init(BuildContext context) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (_useEmulator) {
      await _connectToEmulator();
    }
  }

  Future<void> _connectToEmulator() async {
    final host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
    const authPort = 9099;
    const databasePort = 9000;

    if (kDebugMode) {
      print('Running with local emulator');
    }

    FirebaseDatabase.instance.useDatabaseEmulator(host, databasePort);
    FirebaseAuth.instance.useAuthEmulator(host, authPort);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: init(context),
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.blue,
            ),
            home: snapshot.connectionState == ConnectionState.waiting
                ? const LoadingPage()
                : const AuthGate(),
          );
        });
  }
}
