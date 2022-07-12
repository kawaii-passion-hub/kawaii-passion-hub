import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kawaii_passion_hub/dashboard.dart';
import 'package:flutterfire_ui/auth.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      // If the user is already signed-in, use it as initial data
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return SignInScreen(
              subtitleBuilder: (context, action) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                      'Welcome to FlutterFire UI! Please sign in to continue.'),
                );
              },
              footerBuilder: (context, _) {
                return const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'Copyright @twilker',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              },
              showAuthActionSwitch: false,
              sideBuilder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset('assets/icon.jpg'),
                  ),
                );
              },
              headerBuilder: (context, constraints, _) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset('assets/icon.jpg'),
                  ),
                );
              },
              providerConfigs: const [
                GoogleProviderConfiguration(
                  clientId:
                      '996108416049-8fdpqmhqasndqa8kiacr00kbavvciqt8.apps.googleusercontent.com',
                ),
              ]);
        }

        // Render your application if authenticated
        return const Dashboard(title: "Title");
      },
    );
  }
}
