import 'package:flutter/material.dart';
import 'package:yoda_res/screens/profile/profile.dart';

import 'screens/cart/cart.dart';
import 'screens/home/home.dart';
import 'utils/utils.dart';

class Routes {
  static Map<String, WidgetBuilder> get getAllRoutes => _routes;

  static Route getRouteGenerate(RouteSettings settings) =>
      _routeGenerate(settings);

  static final Map<String, WidgetBuilder> _routes = {
    RouteList.home: (context) => HomeScreen(),
    // RouteList.register: (context) => RegistrationScreen(),
    RouteList.cart: (context) => CartScreen(),
    RouteList.profile: (context) => ProfileScreen(),
    // RouteList.contact: (context) => ContactUsScreen(),
  };

  // function to give specific build route for a route
  static Route _routeGenerate(RouteSettings settings) {
    switch (settings.name) {
      default:
        return MaterialPageRoute(
          builder: getRouteByName(settings.name)!,
          // maintainState: false,
          // fullscreenDialog: true,
        );
    }
  }

  static WidgetBuilder? getRouteByName(String? name) {
    if (_routes.containsKey(name) == false) {
      return _routes[RouteList.home];
    }
    return _routes[name!];
  }
}
