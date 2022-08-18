import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/utils/utils.dart';

class OrderViewModel extends ReactiveViewModel {
  final log = getLogger('OrderViewModel');

  final _navService = locator<NavigationService>();
  final _orderService = locator<OrderService>();
  final _dialogService = locator<DialogService>();
  final _userService = locator<UserService>();

//------------------------ ORDER PART ----------------------------//

  List<Order>? get orders => _orderService.orders;

  /// ORDER PAG
  int _page = 1;
  int get page => _page;
  bool get isPullUpEnabled => _orderService.isPullUpEnabled;
  bool get isFetchingOrders => _orderService.isFetchingOrders;

  //------------------ PAGINATION ---------------------//

  /// ORDER PAG
  /// ENABLES SmartRefresher's pull up function
  void enablePullUp() {
    _page = 1;
    _orderService.enablePullUp();
  }

  /// GETS initial orders
  Future getInitialOrders() async =>
      await runBusyFuture(_orderService.getPaginatedOrders());

  /// ORDER PAG
  /// GETS all orders
  Future getMorePaginatedOrders() async {
    _page++;
    log.v('getMorePaginatedOrders() with _page: $_page');
    await runBusyFuture(_orderService.getPaginatedOrders(page: _page));
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
    if (order.dostawkaPrice != null) totalOrderSum += order.dostawkaPrice!;
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
        var pos = _vols.indexOf(
            vol); // This part is used to put ,(comma) after each concatenated and doesn't put for the latest one

        if (pos == _vols.length - 1 && _cuss.isEmpty)
          concatenatedString.write('${vol.volumeName}');
        else
          concatenatedString.write('${vol.volumeName}, ');
      });

    /// Step 3. For each found _cuss concatenate its name to one text
    if (_cuss.isNotEmpty)
      _cuss.forEach((cus) {
        var pos = _cuss.indexOf(
            cus); // This part is used to put ,(comma) after each concatenated and doesn't put for the latest one

        if (pos == _cuss.length - 1)
          concatenatedString.write('${cus.customizableName}');
        else
          concatenatedString.write('${cus.customizableName}, ');
      });

    return concatenatedString.toString();
  }

//------------------------ DIALOGS ----------------------------//

  bool _isCancelingOrder = false;
  bool get isCancelingOrder => _isCancelingOrder;

  /// SHOWS cancel waiting order Dialog
  Future showCancelWaitingOrderDialog(
    int orderId,
    Function()? onSuccessForView,
    Function()? onFailForView,
  ) async {
    log.i('showCancelWaitingOrderDialog()');
    DialogResponse<dynamic>? respData = await _dialogService.showCustomDialog(
      variant: DialogType.cancelWaitingOrder,
      title: LocaleKeys.wannaCancelOrder,
      mainButtonTitle: LocaleKeys.noOrder,
      secondaryButtonTitle: LocaleKeys.yes,
      showIconInMainButton: false,
      barrierDismissible: true,
    );
    if (respData!.data == true) {
      await runBusyFuture(
        _userService.cancelOrder(
          orderId,
          () async {
            onSuccessForView!();

            /// TODO: Optimize order pagination
            /// REITINITIALIZES ORDERS
            enablePullUp();
            await getInitialOrders();
          },
          () => onFailForView!(),
        ),
        busyObject: orderId,
      );
    }
  }

  /// SHOWS cancel accepted order Dialog
  Future showCancelAcceptedOrderDialog() async {
    log.i('showCancelAcceptedOrderDialog()');
    await _dialogService.showCustomDialog(
      variant: DialogType.cancelAcceptedOrder,
      title: LocaleKeys.orderIsPreparing,
      data: LocaleKeys.toCancelOrderCallRes,
      showIconInMainButton: false,
      barrierDismissible: true,
    );
  }

  /// MAKES a call to driver
  Future<void> makePhoneCallToDriver(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    log.v('phoneNumber: $phoneNumber');
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  /// SHOWS rate order Dialog
  Future showRateOrderDialog(Order order) async {
    log.i('showRateOrderDialog()');
    DialogResponse<dynamic>? respData = await _dialogService.showCustomDialog(
      variant: DialogType.rateOrder,
      showIconInMainButton: false,
      barrierDismissible: true,
      data: NotificationModel(
        id: order.id.toString(),
        resId: order.restaurant!.id.toString(),
        title: order.restaurant!.name,
        status: order.status.toString(),
        selfPickUp: order.selfPickUp.toString(),
      ),
    );
    if (respData!.data != null && respData.data == true) {
      /// TODO: Optimize order pagination
      /// REITINITIALIZES ORDERS
      enablePullUp();
      await getInitialOrders();
    }
  }

//------------------------ ORDER SUCCESS PART ----------------------------//

  /// NAVIGATES to Home by removing all previous routes
  Future<void> navToHomeByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.homeView);

  /// NAVIGATES to Orders by removing all previous routes
  Future<void> navToOrdersByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.ordersView);

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_orderService];
}
