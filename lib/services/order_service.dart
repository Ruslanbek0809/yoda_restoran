import 'package:stacked/stacked.dart';

import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../models/models.dart';
import 'services.dart';

// 1 For Reactive View
class OrderService with ReactiveServiceMixin {
  final log = getLogger('OrderService');

  OrderService() {
    // 2
    listenToReactiveValues([isFetchingOrders]);
  }

  final _userService = locator<UserService>();

  Promocode? _promocode;

  Promocode? get promocode => _promocode;

  List<Order>? _orders = [];
  List<Order>? get orders => _orders;

  // 3
  ReactiveValue<bool> _isFetchingOrders =
      ReactiveValue<bool>(false); // Custom busy for HomeView
  bool get isFetchingOrders => _isFetchingOrders.value;

  Future<void> getOrdersFromNotifications() async {
    _isFetchingOrders.value = true;
    _orders = await _userService.getOrders();
    _isFetchingOrders.value = false;
  }

  /// GETS orders for this user
  Future<void> getOrders() async {
    _orders = await _userService.getOrders();
  }
}
