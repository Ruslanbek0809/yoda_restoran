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

  /// CONCATENATES all orderMeals' vols and customs into one string
  String? getConcatenateVolsCustoms(OrderItem _orderItem) {
    StringBuffer concatenatedString = StringBuffer();

    List<Volume> _vols = [];
    List<Customizable> _cuss = [];

    /// Step 1. If there is any selected vols, here it FINDS and ADDS found volume with this id from volumes inside gVolumes
    if (_orderItem.volumePrices!.isNotEmpty)
      _orderItem.volumePrices!.forEach((vol) {
        _orderItem.mealJson!.gVolumes!.forEach((_mainVolume) {
          Volume? volFound = _mainVolume.volumes!.firstWhere(
            (_vol) => _vol.id == vol,
            orElse: () => Volume(id: -1),
          );
          if (volFound.id != -1) _vols.add(volFound);
        });
      });

    /// Step 2. If there is any selected cuss, here it FINDS and ADDS found customizable with this id from customizables inside gCustomizedMeals
    if (_orderItem.costumizedMeals!.isNotEmpty)
      _orderItem.costumizedMeals!.forEach((cus) {
        _orderItem.mealJson!.gCustomizables!.forEach((_mainCus) {
          Customizable? cusFound = _mainCus.customizables!.firstWhere(
            (_cus) => _cus.id == cus,
            orElse: () => Customizable(id: -1),
          );
          if (cusFound.id != -1) _cuss.add(cusFound);
        });
      });

    /// Step 3. For each found _vols concatenate its name to one text
    if (_vols.isNotEmpty)
      _vols.forEach((vol) {
        concatenatedString.write('${vol.volumeName} ');
      });

    /// Step 3. For each found _cuss concatenate its name to one text
    if (_cuss.isNotEmpty)
      _cuss.forEach((cus) {
        concatenatedString.write('${cus.customizableName} ');
      });

    return concatenatedString.toString();
  }

//------------------------ ORDER SUCCESS PART ----------------------------//

  /// NAVIGATES to Home by removing all previous routes
  Future<void> navToHomeByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.homeView);

  /// NAVIGATES to Orders by removing all previous routes
  Future<void> navToOrdersByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.ordersView);
}
