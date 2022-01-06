import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/services.dart';

class OrderViewModel extends BaseViewModel {
  final log = getLogger('OrderViewModel');

  final _navService = locator<NavigationService>();
  final _orderService = locator<OrderService>();

//------------------------ ORDER PART ----------------------------//

  List<Order>? get orders => _orderService.orders;

  /// GETS all orders
  Future getOrders() async {
    await runBusyFuture(_orderService.getOrders());
    log.i('orders length: ${orders!.length} ');
  }

  /// GETS getPromocodePrice
  num getPromocodePrice(Order order) {
    num totalPromocodePrice = 0;

    if (order.promocode != null) {
      if (order.promocode!.promoType == 1)
        totalPromocodePrice = order.promocode!.discount!;
      else
        totalPromocodePrice =
            (order.totPrice! / 100) * order.promocode!.discount!;
    }
    return totalPromocodePrice;
  }

  /// GETS getTotalOrderSum with promocode
  num getTotalOrderSumWithPromocode(Order order) {
    num totalOrderSum = order.totPrice!;

    if (order.promocode != null) {
      if (order.promocode!.promoType == 1)
        totalOrderSum -= order.promocode!.discount!;
      else
        totalOrderSum = order.totPrice! - getPromocodePrice(order);
    }
    return totalOrderSum;
  }

//------------------------ ORDER SUCCESS PART ----------------------------//

  /// NAVIGATES to Home by removing all previous routes
  Future<void> navToHomeByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.homeView);

  /// NAVIGATES to Orders by removing all previous routes
  Future<void> navToOrdersByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.ordersView);
}
