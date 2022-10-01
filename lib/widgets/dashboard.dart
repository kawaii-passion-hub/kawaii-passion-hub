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

          Diagnostics diagnostics = calculateDiagnostics(snapshot.data!);

          Size size = MediaQuery.of(context).size;
          TextStyle cardTextStyle = const TextStyle(
            fontFamily: 'Montserrat Regular',
            fontSize: 16,
            color: Color.fromARGB(255, 98, 98, 98),
          );
          TextStyle cardDataStyle = cardTextStyle.apply(fontSizeFactor: 2);
          TextStyle negativeCardDataStyle = cardDataStyle.apply(
            color: const Color.fromARGB(255, 255, 105, 105),
          );
          TextStyle positiveCardDataStyle = cardDataStyle.apply(
            color: const Color.fromARGB(255, 167, 222, 115),
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
                                      diagnostics.openOrders.toString(),
                                      style: cardDataStyle,
                                    ),
                                  ),
                                  Text('Open Orders', style: cardTextStyle),
                                ],
                              ),
                            ),
                            Card(
                              elevation: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 60,
                                    child: Text(
                                      '${diagnostics.revenue.toStringAsFixed(2)}€',
                                      style: cardDataStyle,
                                    ),
                                  ),
                                  Text('Revenue', style: cardTextStyle),
                                ],
                              ),
                            ),
                            Card(
                              elevation: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 60,
                                    child: Text(
                                      '${diagnostics.yearlyRevenue.toStringAsFixed(2)}€',
                                      style: cardDataStyle,
                                    ),
                                  ),
                                  Text('Yearly Revenue', style: cardTextStyle),
                                ],
                              ),
                            ),
                            Card(
                              elevation: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 60,
                                    child: Text(
                                      "${(diagnostics.mtm * 100).toStringAsFixed(2)}%",
                                      style: diagnostics.mtm < 0
                                          ? negativeCardDataStyle
                                          : positiveCardDataStyle,
                                    ),
                                  ),
                                  Text('Month-to-Month', style: cardTextStyle),
                                ],
                              ),
                            ),
                            Card(
                              elevation: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 60,
                                    child: Text(
                                      "${(diagnostics.yty * 100).toStringAsFixed(2)}%",
                                      style: diagnostics.yty < 0
                                          ? negativeCardDataStyle
                                          : positiveCardDataStyle,
                                    ),
                                  ),
                                  Text('Year-to-Year', style: cardTextStyle),
                                ],
                              ),
                            ),
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

  Diagnostics calculateDiagnostics(OrdersUpdated event) {
    List<Order> orders = event.orders;
    int openOrders = orders.where((order) => order.state == 'Open').length;
    DateTime start = DateTime.now().subtract(const Duration(days: 30));
    DateTime end = DateTime.now();
    double revenue = calculateRevenue(orders, start, end);
    end = start;
    start = start.subtract(const Duration(days: 30));
    double compare = calculateRevenue(orders, start, end);
    double mtm = (compare - revenue) / compare;
    end = DateTime.now();
    start = DateTime(DateTime.now().year);
    double yearlyRevenue = calculateRevenue(orders, start, end);
    end = DateTime(end.year - 1, end.month, end.day, end.hour, end.minute);
    start = DateTime(DateTime.now().year - 1);
    compare = calculateRevenue(orders, start, end);
    double yty = (compare - yearlyRevenue) / compare;
    return Diagnostics(openOrders, yty, mtm, revenue, yearlyRevenue);
  }

  double calculateRevenue(List<Order> orders, DateTime start, DateTime end) {
    return orders
        .where((order) =>
            order.issued.isAfter(start) && order.issued.isBefore(end))
        .fold(0.0, (previousValue, order) => previousValue + order.price);
  }
}

class Diagnostics {
  final int openOrders;
  final double yty;
  final double mtm;
  final double revenue;
  final double yearlyRevenue;

  Diagnostics(
      this.openOrders, this.yty, this.mtm, this.revenue, this.yearlyRevenue);
}
