import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kawaii_passion_hub_orders/kawaii_passion_hub_orders.dart';
import 'package:kawaii_passion_hub_orders/model.dart';

class Dashboard extends StatelessWidget {
  Dashboard({Key? key}) : super(key: key) {
    globalBus = GetIt.I.get();
  }

  late final EventBus globalBus;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OrdersUpdated>(
        stream: globalBus.on(),
        initialData: OrdersUpdated(OrdersState.current),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.orders.isEmpty) {
            return const LoadingPage();
          }

          List<Order> orders = snapshot.data!.orders;

          Size size = MediaQuery.of(context).size;
          TextStyle cardTextStyle = const TextStyle(
            fontFamily: 'Montserrat Regular',
            fontSize: 16,
            color: Color.fromARGB(255, 98, 98, 98),
          );
          TextStyle cardDataStyle = const TextStyle(
            fontFamily: 'Montserrat Regular',
            fontSize: 40,
            color: Color.fromARGB(255, 98, 98, 98),
          );

          return Scaffold(
            body: Stack(
              children: [
                Container(
                  height: size.height / 3,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    alignment: Alignment.topCenter,
                    image: AssetImage('assets/top_header.png'),
                  )),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Container(
                          height: 64,
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              CircleAvatar(
                                radius: 32,
                                backgroundImage: AssetImage('assets/icon.jpg'),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Center(
                                child: Text(
                                  'Kawaii Passion',
                                  style: TextStyle(fontSize: 24),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          primary: false,
                          children: [
                            Card(
                              elevation: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 60,
                                    child: Text(
                                      orders
                                          .where((element) =>
                                              element.state == 'Open')
                                          .length
                                          .toString(),
                                      style: cardDataStyle,
                                    ),
                                  ),
                                  Text('Open Orders', style: cardTextStyle),
                                ],
                              ),
                            )
                          ],
                        )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
