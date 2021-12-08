import 'package:flutter/material.dart';
import 'package:yoda_res/screens/profile/profile.dart';
import 'screens/cart/cart.dart';
import 'screens/cart/order/order.dart';
// import 'screens/home/home.dart';
import 'utils/utils.dart';

class Routes {
  static Map<String, WidgetBuilder> get getAllRoutes => _routes;

  static Route getRouteGenerate(RouteSettings settings) =>
      _routeGenerate(settings);

  static final Map<String, WidgetBuilder> _routes = {
    // RouteList.home: (context) => HomeScreen(),
    // RouteList.register: (context) => RegistrationScreen(),
    RouteList.cart: (context) => CartScreen(),
    RouteList.orders: (context) => OrdersScreen(),
    RouteList.orderSuccess: (context) => OrderSuccessScreen(),
    RouteList.profile: (context) => ProfileScreen(),
    RouteList.addresses: (context) => AddressesScreen(),
    RouteList.addressAddEdit: (context) => AddressAddEditScreen(),
    RouteList.contact: (context) => ContactUsScreen(),
    RouteList.rateUs: (context) => RateUsScreen(),
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
