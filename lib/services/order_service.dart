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

  /// ORDER PAG
  bool _isPullUpEnabled = true;
  bool get isPullUpEnabled => _isPullUpEnabled;

  // 3
  ReactiveValue<bool> _isFetchingOrders =
      ReactiveValue<bool>(false); // Custom busy for HomeView
  bool get isFetchingOrders => _isFetchingOrders.value;

  Future<void> getOrdersFromNotifications() async {
    _isFetchingOrders.value = true;
    _orders = await _userService.getOrders();
    _isFetchingOrders.value = false;
  }

  /// ORDER PAG
  void enablePullUp() => _isPullUpEnabled = true;

  /// ORDER PAG
  Future<void> getPaginatedOrders({int page = 1}) async {
    log.v('OrderService getPaginatedOrders()');
    List<Order> _fetchedOrders = [];
    String? _pagNext;
    await _userService.getPaginatedOrders(
      page,
      (pagOrders, pagNext) {
        if (pagOrders != null && pagOrders.isNotEmpty)
          _fetchedOrders = pagOrders;
        if (pagNext != null) _pagNext = pagNext;
      },
    );

    log.v(
        '_fetchedOrders.length: ${_fetchedOrders.length}, _pagNext:$_pagNext');

    if (_pagNext == null) _isPullUpEnabled = false;

    if (page == 1)
      _orders = _fetchedOrders;
    else
      _orders = [..._orders!, ..._fetchedOrders];

    log.v(
        '_orders!.length: ${_orders!.length}; _isPullUpEnabled:$_isPullUpEnabled');
  }
}
