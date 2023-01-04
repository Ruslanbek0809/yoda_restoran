import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../models/models.dart';
import 'services.dart';

// 1 For Reactive View
class OrderService {
  final log = getLogger('OrderService');

  final _userService = locator<UserService>();

  Promocode? _promocode;

  Promocode? get promocode => _promocode;

  List<Order> _orders = [];
  List<Order> get orders => _orders;

  //*ORDER PAG
  int _page = 1;
  int get page => _page;
  bool _isPullUpEnabled = true;
  bool get isPullUpEnabled => _isPullUpEnabled;

  //*ORDER PAG
  Future<void> getInitialPaginatedOrders() async {
    log.v('====> START OrderService getInitialPaginatedOrders()');

    //*INITIALIZE _page with 1 and _isPullUpEnabled
    _page = 1;
    _isPullUpEnabled = true;

    List<Order> _fetchedOrders = [];
    String? _pagNext;

    //*FETCH PART
    await _userService.getPaginatedOrders(
      _page,
      (pagOrders, pagNext) {
        if (pagOrders != null && pagOrders.isNotEmpty)
          _fetchedOrders = pagOrders;
        if (pagNext != null) _pagNext = pagNext;
      },
    );

    //*CHECKS next pagination is NULL or NOT
    if (_pagNext == null) _isPullUpEnabled = false;

    //*ASSIGNS last _fetchedOrders to _orders
    _orders = _fetchedOrders;

    log.v(
        '====> END OrderService getInitialPaginatedOrders() _page: $_page, _orders.length: ${_orders.length}; _isPullUpEnabled:$_isPullUpEnabled');
  }

  //*ORDER PAG
  Future<void> getPaginatedOrders() async {
    log.v('====> START OrderService getPaginatedOrders()');

    //*INCREMENTS _page +1
    _page = _page + 1;

    List<Order> _fetchedOrders = [];
    String? _pagNext;

    //*FETCH PART
    await _userService.getPaginatedOrders(
      page,
      (pagOrders, pagNext) {
        if (pagOrders != null && pagOrders.isNotEmpty)
          _fetchedOrders = pagOrders;
        if (pagNext != null) _pagNext = pagNext;
      },
    );

    //*CHECKS next pagination is NULL or NOT
    if (_pagNext == null) _isPullUpEnabled = false;

    //*ASSIGNS last _fetchedOrders to _orders
    _orders = [..._orders, ..._fetchedOrders];

    log.v(
        '====> END OrderService getPaginatedOrders() _page: $_page, _orders.length: ${_orders.length}; _isPullUpEnabled:$_isPullUpEnabled');
  }
}
