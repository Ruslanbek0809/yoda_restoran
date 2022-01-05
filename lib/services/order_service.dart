import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../models/models.dart';
import 'services.dart';

class OrderService {
  final log = getLogger('OrderService');

  final _userService = locator<UserService>();

  Promocode? _promocode;

  Promocode? get promocode => _promocode;

  List<Order>? _orders = [];
  List<Order>? get orders => _orders;

  /// GETS orders for this user
  Future<void> getOrders() async {
    _orders = await _userService.getOrders();
  }
}
