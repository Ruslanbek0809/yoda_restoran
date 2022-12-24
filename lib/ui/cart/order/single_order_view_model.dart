import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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

//* NEW CODE
class SingleOrderViewModel extends ReactiveViewModel {
  final log = getLogger('SingleOrderViewModel');
  final Order? order;
  final OrderViewModel? orderViewModel;
  SingleOrderViewModel({this.order, this.orderViewModel});

  final _navService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _userService = locator<UserService>();
  final _bottomSheetService = locator<BottomSheetService>();

  //* NEW CODE
  final _hiveDbService = locator<HiveDbService>();

  //* NEW CODE
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

  /// Function that FIRES first in SingleOrderViewModel
  void initSingleOrder() {
    /// INITIALIZES _orderStatusText
    switch (order!.status) {
      case 1:
        _orderStatusText = LocaleKeys.orderWaiting.tr();
        break;
      case 2:
        _orderStatusText = LocaleKeys.orderAccepted.tr();
        break;
      case 3:
        _orderStatusText = order!.selfPickUp!
            ? LocaleKeys.orderReady.tr()
            : LocaleKeys.orderSent.tr();
        break;
      case 4:
        _orderStatusText = order!.selfPickUp!
            ? LocaleKeys.orderTaken.tr()
            : LocaleKeys.orderDelivered.tr();
        break;
      default:
        break;
    }

    /// ASSIGNS initial value to _currentOrderExpansionState
    _currentOrderExpansionState =
        order!.status == 2 || order!.status == 1 ? true : false;

    /// CREATES and INITIALIZES orderStatuses for this order
    for (int i = 0; i < _orderTimelines.length; i++) {
      /// INITIALIZES _orderStatusText
      switch (_orderTimelines[i].id) {
        case 2:
          _orderTimelines[i].name = LocaleKeys.orderAccepted.tr();
          if (order!.kitchenAt != null)
            _orderTimelines[i].orderStatusAt = order!.kitchenAt!;
          break;
        case 3:
          _orderTimelines[i].name = order!.selfPickUp!
              ? LocaleKeys.orderReady.tr()
              : LocaleKeys.orderSent.tr();
          if (order!.driverAt != null)
            _orderTimelines[i].orderStatusAt = order!.driverAt!;
          break;
        case 4:
          _orderTimelines[i].name = order!.selfPickUp!
              ? LocaleKeys.orderTaken.tr()
              : LocaleKeys.orderDelivered.tr();
          if (order!.deliveredAt != null)
            _orderTimelines[i].orderStatusAt = order!.deliveredAt!;
          break;
        default:
          break;
      }
    }
  }

  /// ASSIGNS new value to _currentOrderExpansionState
  void changeCurrentOrderExpansionState(bool value) {
    _currentOrderExpansionState = value;
    notifyListeners();
  }

  /// GETS getPromocodePrice
  num getPromocodePrice() {
    num totalPromocodePrice = 0;

    if (order!.promocode != null) {
      if (order!.promocode!.promoType == 1)
        totalPromocodePrice = order!.promocode!.discount!;
      else
        totalPromocodePrice =
            (order!.totPrice! / 100) * order!.promocode!.discount!;
    }
    return totalPromocodePrice;
  }

  /// GETS getTotalOrderSum with promocode
  num getTotalOrderSumWithPromocode() {
    num totalOrderSum = order!.totPrice!;

    if (order!.promocode != null) {
      if (order!.promocode!.promoType == 1)
        totalOrderSum -= order!.promocode!.discount!;
      else
        totalOrderSum = order!.totPrice! - getPromocodePrice();
    }
    if (order!.dostawkaPrice != null) totalOrderSum += order!.dostawkaPrice!;
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
    if (respData!.data != null && respData.data == true) {
      await runBusyFuture(
        _userService.cancelOrder(
          orderId,
          () async {
            onSuccessForView!();

            /// REINITIALIZES ORDERS
            /// TODO: Optimize if possible
            await orderViewModel!.getInitialOrders();
          },
          () => onFailForView!(),
        ),
        busyObject: orderId,
      );
    }
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
      /// REINITIALIZES ORDERS
      /// TODO: Optimize if possible
      await orderViewModel!.getInitialOrders();
    }
  }

//------------------------ ORDER DELETE DIALOG ----------------------------//

  /// SHOWS ORDER DELETE Dialog
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
          order!.id!,
          () async {
            onSuccessForView!();

            /// REINITIALIZES ORDERS
            /// TODO: Optimize if possible
            await orderViewModel!.getInitialOrders();
          },
          () => onFailForView!(),
        ),
        busyObject: order!.id!,
      );
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// CALLS SOSendCodeConfirmationBottomSheetView
  Future<void> showCustomSendCodeConfirmationBottomSheet(
    OrderPaymentCreateBankOrder paymentCreateBankOrder,
  ) async {
    log.i('');
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.sendCodeConfirmation,
      enableDrag: true,
      barrierDismissible: true,
      isScrollControlled: true,
      data: paymentCreateBankOrder,
    );
  }

  /// POST after CONFIRM button is pressed
  Future<void> onConfirmButtonPressed({
    Function(OrderPaymentCreateBankOrder)? onSuccessForView,
    Function()? onFailForView,
  }) async {
    log.v('onConfirmButtonPressed()');

    _isLoading = true;
    notifyListeners();

    await runBusyFuture(
      //* NEW CODE for online payment fetch from backend
      _userService.createBankOrder(
        hiveCreditCards[0],
        order!,
        false,
        0,
        (OrderPaymentCreateBankOrder paymentCreateBankOrder) async {
          _isLoading = false;
          notifyListeners();
          onSuccessForView!(paymentCreateBankOrder);
        },
        () {
          _isLoading = false;
          notifyListeners();
          onFailForView!();
        },
      ),

      // //* NEW CODE  STEP 1
      // _userService.postRegisterOnlinePayment(
      //   order!,
      //   false,
      //   0,
      //   (OrderPaymentRegister paymentRegister) async {
      //     //* NEW CODE COMMENT
      //     // _isLoading = false;
      //     // notifyListeners();
      //     // log.v('paymentRegister.formUrl: ${paymentRegister.formUrl}');
      //     // // onSuccessForView!(paymentRegister);

      //     //* NEW CODE  STEP 2
      //     await _userService.postProcessOnlinePayment(
      //       hiveCreditCards[0],
      //       paymentRegister,
      //       (OrderPaymentAcsUrl paymentAcsUrl) async {
      //         //* NEW CODE STEP 3
      //         await _userService.postAcsUrl(
      //           paymentRegister,
      //           paymentAcsUrl,
      //           (String paResValue) async {
      //             // _isLoading = false;
      //             // notifyListeners();
      //             //* NEW CODE STEP 4
      //             await _userService.postFinish3ds(
      //               paymentRegister,
      //               paymentAcsUrl,
      //               paResValue,
      //               () async {
      //                 _isLoading = false;
      //                 notifyListeners();
      //               },
      //               () {
      //                 _isLoading = false;
      //                 notifyListeners();
      //                 onFailForView!();
      //               },
      //             );
      //           },
      //           () {
      //             _isLoading = false;
      //             notifyListeners();
      //             onFailForView!();
      //           },
      //         );
      //       },
      //       () {
      //         _isLoading = false;
      //         notifyListeners();
      //         onFailForView!();
      //       },
      //     );
      //   },
      //   () {
      //     _isLoading = false;
      //     notifyListeners();
      //     onFailForView!();
      //   },
      // ),
    );
  }

  bool _isPaymentLoading = false;
  bool get isPaymentLoading => _isPaymentLoading;

  bool _isPaymentPanelsFinished = false;
  bool get isPaymentPanelsFinished => _isPaymentPanelsFinished;

  /// Enum for order payment status
  OrderPaymentStatus _isPaymentSuccess = OrderPaymentStatus.idle;
  OrderPaymentStatus get isPaymentSuccess => _isPaymentSuccess;

  /// Function onConsoleMessage
  Future<void> onConsoleMessage({
    OrderPaymentRegister? paymentRegister,
    InAppWebViewController? controller,
    ConsoleMessage? consoleMessage,
  }) async {
    log.v('onConsoleMessage => $consoleMessage');

    final _isErrorTextExists = consoleMessage!.message.contains('ErrorCode');
    final _isErrorCodeExists = consoleMessage.message.contains('5');
    log.v(
        'onConsoleMessage => _isErrorTextExists: $_isErrorTextExists, _isErrorCodeExists: $_isErrorCodeExists, really ERROR: ${_isErrorTextExists && _isErrorCodeExists}');

    if (_isErrorTextExists && _isErrorCodeExists) {
      _isPaymentLoading = true;
      _isPaymentSuccess = OrderPaymentStatus.idle;

      /// STARTS _isPaymentLoading part in bottom sheet
      _isPaymentPanelsFinished = true;
      notifyListeners();

      await Future.delayed(Duration(milliseconds: 500));

      ///* COMMENTED
      // /// CHECKS ONLINE PAYMENT ORDER STATUS
      // await runBusyFuture(
      //   _userService.checkOnlinePaymentOrderStatus(
      //     _isOnlinePaymentRetrySuccess
      //         ? _retryOnlinePaymentRegister!
      //         : paymentRegister!,
      //     () async {
      //       _isPaymentLoading = false;
      //       _isPaymentSuccess = OrderPaymentStatus.success;

      //       /// Below _isOnlinePaymentRetrySuccess is used for retryOnlinePaymentRegister
      //       _isOnlinePaymentRetrySuccess = false;
      //       notifyListeners();

      //       /// PATCHS ORDER PAID VAR
      //       await _userService.patchOrderToPaid(
      //         order!.id!,
      //         () async {
      //           /// REINITIALIZES ORDERS
      //           /// TODO: Optimize if possible
      //           await orderViewModel!.getInitialOrders();
      //         },
      //         () {},
      //       );
      //     },
      //     () {
      //       _isPaymentLoading = false;
      //       _isPaymentSuccess = OrderPaymentStatus.fail;

      //       /// Below _isOnlinePaymentRetrySuccess is used for retryOnlinePaymentRegister
      //       _isOnlinePaymentRetrySuccess = false;
      //       notifyListeners();
      //     },
      //   ),
      // );
    }
  }

  /// SHOWS ONLINE PAYMENT FAIL Dialog
  Future showOnlinePaymentFailDialog() async {
    log.i('showOnlinePaymentFailDialog()');
    await _dialogService.showCustomDialog(
      variant: DialogType.onlinePaymentFail,
      title: LocaleKeys.online_payment_fail,
      data: LocaleKeys.online_payment_fail_info,
      showIconInMainButton: false,
      barrierDismissible: true,
    );
  }

  /// SHOWS ONLINE PAYMENT SUCCESS Dialog
  Future showOnlinePaymentSuccessDialog() async {
    log.i('showOnlinePaymentSuccessDialog()');
    await _dialogService.showCustomDialog(
      variant: DialogType.onlinePaymentSuccess,
      title: LocaleKeys.online_payment_success,
      data: '',
      showIconInMainButton: false,
      barrierDismissible: true,
    );
  }

  bool _isChangeToCashLoading = false;
  bool get isChangeToCashLoading => _isChangeToCashLoading;

  /// POST after CONFIRM button is pressed
  Future<void> onChangeToCashButtonPressed({
    Function()? onSuccessForView,
    Function()? onFailForView,
  }) async {
    log.v('onChangeToCashButtonPressed()');

    _isChangeToCashLoading = true;
    notifyListeners();

    ///* COMMENTED
    // await runBusyFuture(
    //   _userService.patchOrderOnlineToCash(
    //     order!.id!,
    //     () async {
    //       /// REINITIALIZES ORDERS
    //       /// TODO: Optimize if possible
    //       await orderViewModel!.getInitialOrders();
    //       _isChangeToCashLoading = false;
    //       notifyListeners();
    //       onSuccessForView!();
    //     },
    //     () {
    //       _isChangeToCashLoading = false;
    //       notifyListeners();
    //       onFailForView!();
    //     },
    //   ),
    // );
  }

  OrderPaymentRegister? _retryOnlinePaymentRegister;
  OrderPaymentRegister? get retryOnlinePaymentRegister =>
      _retryOnlinePaymentRegister;

  bool _isOnlinePaymentRetrySuccess = false;
  bool get isOnlinePaymentRetrySuccess => _isOnlinePaymentRetrySuccess;

  int _onlineRetryCounter = 0;
  int get onlineRetryCounter => _onlineRetryCounter;

  bool _isOnlinePaymentRetryLoading = false;
  bool get isOnlinePaymentRetryLoading => _isOnlinePaymentRetryLoading;

  /// POST after ONLINE PAYMENT RETRY button is pressed
  Future<void> onOnlinePaymentRetryButtonPressed({
    Function()? onSuccessForView,
    Function()? onFailForView,
  }) async {
    log.v('onOnlinePaymentRetryButtonPressed()');

    /// STARTS new _onlineRetryCounter for this specific order
    _onlineRetryCounter = _onlineRetryCounter + 1;
    _isOnlinePaymentRetryLoading = true;
    notifyListeners();

    ///* COMMENTED
    // await runBusyFuture(
    //   _userService.postRegisterOnlinePayment(
    //     order!,
    //     true,
    //     _onlineRetryCounter,
    //     (OrderPaymentRegister paymentRegister) async {
    //       _isOnlinePaymentRetryLoading = false;

    //       /// STARTS _isPaymentLoading part in bottom sheet
    //       _isPaymentPanelsFinished = false;

    //       _isOnlinePaymentRetrySuccess = true;
    //       _retryOnlinePaymentRegister = paymentRegister;
    //       notifyListeners();
    //       onSuccessForView!();
    //     },
    //     () {
    //       _isOnlinePaymentRetryLoading = false;
    //       notifyListeners();
    //       onFailForView!();
    //     },
    //   ),
    // );
  }

//------------------------ ORDER SUCCESS PART ----------------------------//

  /// NAVIGATES to Home by removing all previous routes
  Future<void> navToHomeByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.homeView);

  /// NAVIGATES to Orders by removing all previous routes
  Future<void> navToOrdersByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.ordersView);

  //* NEW CODE
  @override
  List<ReactiveServiceMixin> get reactiveServices => [_hiveDbService];
}
