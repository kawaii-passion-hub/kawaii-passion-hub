import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'event_bus_widget.dart';
import 'package:kawaii_passion_hub_authentication/kawaii_passion_hub_authentication.dart'
    as auth;

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key, required this.nextScreenBuilder}) : super(key: key);

  final Widget Function(BuildContext) nextScreenBuilder;

  @override
  Widget build(BuildContext context) {
    Widget result = StreamBuilder<auth.UserInformationUpdated?>(
      stream:
          EventBusWidget.of(context).eventBus.on<auth.UserInformationUpdated>(),
      initialData: auth.AuthentificationState.current != null
          ? auth.UserInformationUpdated(auth.AuthentificationState.current!)
          : null,
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.newUser.isAuthenticated) {
          return auth.AuthenticationWidget(
            googleClientId: const String.fromEnvironment('GOOGLE_CLIENT_ID'),
            logo: Image.asset('assets/icon.jpg'),
          );
        }
        if (kDebugMode) {
          print(
              '${snapshot.data!.newUser.name} - ${snapshot.data!.newUser.claims!['whitelisted']}');
        }
        return nextScreenBuilder(context);
      },
    );
    return result;
  }
}
