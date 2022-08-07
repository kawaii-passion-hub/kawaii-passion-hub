import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kawaii_passion_hub/loading_page.dart';
import 'package:firebase_database/firebase_database.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map orders = {};

  Future<void> init() async {
    if (FirebaseAuth.instance.currentUser == null) {
      throw Exception('This should not be possible.');
    }
    final user = FirebaseAuth.instance.currentUser;
    var idToken = await user!.getIdTokenResult(true);
    if (idToken.claims?.containsKey('whitelisted') != true) {
      final stream = FirebaseDatabase.instance
          .ref('metadata/${user.uid}/refreshTime')
          .onValue;
      // ignore: unused_local_variable
      await for (final event in stream) {
        idToken = await user.getIdTokenResult(true);
        if (idToken.claims?.containsKey('whitelisted') == true) {
          break;
        }
      }
    }
    if (idToken.claims!['whitelisted'] != true) {
      throw Exception('Unautherized.');
    }
    final ref = FirebaseDatabase.instance.ref('orders');
    final snapshot = await ref.get();
    if (snapshot.exists) {
      orders = (snapshot.value) as Map;
    } else {
      throw Exception('Invalid Database.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return FutureBuilder(
        future: init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingPage();
          }
          return Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text(widget.title),
            ),
            body: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (_, index) {
                var order = orders.values.elementAt(index);
                return ListTile(
                  onTap: () => print('Tapped'),
                  title: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(order['orderNumber'])),
                  subtitle: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                          '${order['orderCustomer']['firstName']} ${order['orderCustomer']['lastName']} - ${order['positionPrice']} €')),
                );
              },
            ),
          );
        });
  }
}
