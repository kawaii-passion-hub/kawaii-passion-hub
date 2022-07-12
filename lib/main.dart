import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kawaii_passion_hub/auth_gate.dart';
import 'firebase_options.dart';
import 'loading_page.dart';

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
