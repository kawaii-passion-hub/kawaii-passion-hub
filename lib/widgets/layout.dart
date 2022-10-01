import 'package:flutter/material.dart';
import 'package:kawaii_passion_hub/widgets/dashboard.dart';
import 'package:kawaii_passion_hub_orders/kawaii_passion_hub_orders.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-badge.widget.dart';

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MotionTabBar(
        initialSelectedTab: "Dashboard",
        useSafeArea: true, // default: true, apply safe area wrapper
        labels: const ["Dashboard", "Orders"],
        icons: const [Icons.dashboard, Icons.shopping_cart],
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: Colors.blue[600],
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: Colors.blue[900],
        tabIconSelectedColor: Colors.white,
        onTabItemSelected: (int value) {
          setState(() {
            _tabController!.index = value;
          });
        },
      ),
      body: TabBarView(
        physics:
            const NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
        controller: _tabController,
        // ignore: prefer_const_literals_to_create_immutables
        children: <Widget>[
          Dashboard(),
          OrdersDashboard(),
        ],
      ),
    );
  }
}
