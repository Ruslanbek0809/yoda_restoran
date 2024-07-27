import 'package:easy_localization/easy_localization.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../models/hive_models/hive_models.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';
import 'order_view_model.dart';

class SingleOrderViewModel extends ReactiveViewModel {
  final log = getLogger('SingleOrderViewModel');
  final Order order;
  final OrderViewModel orderViewModel;
  SingleOrderViewModel({
    required this.order,
    required this.orderViewModel,
  });

  final _navService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _userService = locator<UserService>();

  final _hiveDbService = locator<HiveDbService>();

  List<HiveCreditCard> get hiveCreditCards => _hiveDbService.hiveCreditCards;

  bool _currentOrderExpansionState = false;
  bool get currentOrderExpansionState => _currentOrderExpansionState;

  String _orderStatusText = '';
  String get orderStatusText => _orderStatusText;

  List<OrderTimeline> _orderTimelines = [
    OrderTimeline(2, 'Default', DateTime.now()),
    OrderTimeline(3, 'Default', DateTime.now()),
    OrderTimeline(4, 'Default', DateTime.now()),
  ];
  List<OrderTimeline> get orderTimelines => _orderTimelines;

  //*Function that FIRES first in SingleOrderViewModel
  void initSingleOrder() {
    //*INITIALIZES _orderStatusText
    switch (order.status) {
      case 1:
        _orderStatusText = LocaleKeys.orderWaiting.tr();
        break;
      case 2:
        _orderStatusText = LocaleKeys.orderAccepted.tr();
        break;
      case 3:
        _orderStatusText = order.selfPickUp!
            ? LocaleKeys.orderReady.tr()
            : LocaleKeys.orderSent.tr();
        break;
      case 4:
        _orderStatusText = order.selfPickUp!
            ? LocaleKeys.orderTaken.tr()
            : LocaleKeys.orderDelivered.tr();
        break;
      default:
        break;
    }

    //*ASSIGNS initial value to _currentOrderExpansionState
    _currentOrderExpansionState =
        order.status == 2 || order.status == 1 ? true : false;

    //*CREATES and INITIALIZES orderStatuses for this order
    for (int i = 0; i < _orderTimelines.length; i++) {
      //*INITIALIZES _orderStatusText
      switch (_orderTimelines[i].id) {
        case 2:
          _orderTimelines[i].name = LocaleKeys.orderAccepted.tr();
          if (order.kitchenAt != null)
            _orderTimelines[i].orderStatusAt = order.kitchenAt!;
          break;
        case 3:
          _orderTimelines[i].name = order.selfPickUp!
              ? LocaleKeys.orderReady.tr()
              : LocaleKeys.orderSent.tr();
          if (order.driverAt != null)
            _orderTimelines[i].orderStatusAt = order.driverAt!;
          break;
        case 4:
          _orderTimelines[i].name = order.selfPickUp!
              ? LocaleKeys.orderTaken.tr()
              : LocaleKeys.orderDelivered.tr();
          if (order.deliveredAt != null)
            _orderTimelines[i].orderStatusAt = order.deliveredAt!;
          break;
        default:
          break;
      }
    }
  }

  //*ASSIGNS new value to _currentOrderExpansionState
  void changeCurrentOrderExpansionState(bool value) {
    _currentOrderExpansionState = value;
    notifyListeners();
  }

  //*GETS getPromocodePrice
  num getPromocodePrice() {
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

  //*GETS getTotalOrderSum with promocode
  num getTotalOrderSumWithPromocode() {
    num totalOrderSum = order.totPrice!;

    if (order.promocode != null) {
      if (order.promocode!.promoType == 1)
        totalOrderSum -= order.promocode!.discount!;
      else
        totalOrderSum = order.totPrice! - getPromocodePrice();
    }
    if (order.dostawkaPrice != null) totalOrderSum += order.dostawkaPrice!;
    return totalOrderSum;
  }

  //*CONCATENATES all orderMeals' vols and customs into one string
  String? getConcatenateVolsCustoms(OrderItem _orderItem) {
    StringBuffer concatenatedString = StringBuffer();

    List<Volume> _vols = [];
    List<Customizable> _cuss = [];

    //*Step 1. If there is any selected vols, here it FINDS and ADDS found volume with this id from volumes inside gVolumes
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

    //*Step 2. If there is any selected cuss, here it FINDS and ADDS found customizable with this id from customizables inside gCustomizedMeals
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

    //*Step 3. For each found _vols concatenate its name to one text
    if (_vols.isNotEmpty)
      _vols.forEach((vol) {
        var pos = _vols.indexOf(
            vol); // This part is used to put ,(comma) after each concatenated and doesn't put for the latest one

        if (pos == _vols.length - 1 && _cuss.isEmpty)
          concatenatedString.write('${vol.volumeName}');
        else
          concatenatedString.write('${vol.volumeName}, ');
      });

    //*Step 3. For each found _cuss concatenate its name to one text
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

//*----------------------- DIALOGS ----------------------------//

  bool _isCancelingOrder = false;
  bool get isCancelingOrder => _isCancelingOrder;

  //*SHOWS cancel waiting order Dialog
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
    if (respData!.data != null && respData.data == true) {
      await runBusyFuture(
        _userService.cancelOrder(
          orderId,
          () async {
            onSuccessForView!();

            //* REINITIALIZES ORDERS
            // TODO: Optimize if possible
            await orderViewModel.getInitialOrders();
          },
          () => onFailForView!(),
        ),
        busyObject: orderId,
      );
    }
  }

  //*MAKES a call to driver
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

  //*SHOWS rate order Dialog
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
      //* REINITIALIZES ORDERS
      // TODO: Optimize if possible
      await orderViewModel.getInitialOrders();
    }
  }

//* ------------------------ ORDER DELETE DIALOG ----------------------------//

  //* SHOWS ORDER DELETE Dialog
  Future showOrderDeleteDialog(
    Function()? onSuccessForView,
    Function()? onFailForView,
  ) async {
    log.i('showOrderDeleteDialog()');
    DialogResponse<dynamic>? respData = await _dialogService.showCustomDialog(
      variant: DialogType.orderDelete,
      title: LocaleKeys.wannaDeleteOrder,
      mainButtonTitle: LocaleKeys.no,
      secondaryButtonTitle: LocaleKeys.delete,
      showIconInMainButton: false,
      barrierDismissible: true,
    );
    if (respData != null && respData.data == true)
      await runBusyFuture(
        _userService.deleteOrder(
          order.id!,
          () async {
            onSuccessForView!();

            //* REINITIALIZES ORDERS
            // TODO: Optimize if possible
            await orderViewModel.getInitialOrders();
          },
          () => onFailForView!(),
        ),
        busyObject: order.id!,
      );
  }

  FlashController? _flashController;

  Future<void> showCustomFlashBar({
    required BuildContext context,
    String msg = LocaleKeys.errorOccured,
    Duration duration = const Duration(seconds: 2),
  }) async {
    await showCustomFlashBarWithFlashController(
      context: context,
      flashController: _flashController,
      msg: msg,
      duration: duration,
      margin: EdgeInsets.only(
        left: 0.1.sw,
        right: 0.1.sw,
        bottom: 0.05.sh,
      ),
    );
  }

//* ------------------------ NAVIGATION ----------------------------//

  //*NAVIGATES to Home by removing all previous routes
  Future<void> navToHomeByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.homeView);

  //*NAVIGATES to Orders by removing all previous routes
  Future<void> navToOrdersByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.ordersView);

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_hiveDbService];
}
