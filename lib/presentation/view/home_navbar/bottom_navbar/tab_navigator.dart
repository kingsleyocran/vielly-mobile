import 'package:flutter/material.dart';

import '../../profile/profile_view.dart';
import '../../bus/bus/bus_view.dart';
import '../../ride/ride_view.dart';


class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}


class TabNavigator extends StatelessWidget {
  TabNavigator({required this.navigatorKey, required this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;

  @override
  Widget build(BuildContext context) {

    Widget? child ;
    if(tabItem == "Page1")
      child = BusView();
    else if(tabItem == "Page2")
      child = RideView();
    else if(tabItem == "Page3")
      child = ProfileView();


    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
            builder: (context) => child!
        );
      },
    );

  }
}