import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';

class CheckoutViewModel extends ReactiveViewModel {
  final log = getLogger('CheckoutViewModel');

  final _checkoutService = locator<CheckoutService>();
  final _hiveDbService = locator<HiveDbService>();
  final _userService = locator<UserService>();
  final _navService = locator<NavigationService>();
  final _toggleButtonService = locator<ToggleButtonService>();

  HiveUser? get currentUser => _userService.currentUser;

  HiveRestaurant? get cartRes => _hiveDbService.cartRes;

  Address? get selectedAddress =>
      _checkoutService.selectedAddress; // For CheckoutBottomSheetView

  bool get isDelivery => _toggleButtonService.isDelivery;

  Promocode? _promocode;
  Promocode? get promocode => _promocode;

  /// DateTime vars
  final now = DateTime.now();
  DateTime? tomorrow;
  DateTime? maxDateTime;
  DateTime? deliveryDateTime;
  String? deliveryDateFormatted = '';

  /// ASSIGNS default value for dateTime
  void getOnModelReady() {
    // deliveryDateTime = now;
    tomorrow = DateTime(now.year, now.month, now.day + 1);
    maxDateTime = DateTime(now.year, now.month, now.day + 1, 20);

    /// Workaround to give default first hive resPaymentTypes
    if (!cartRes!.resPaymentTypes!.contains(selectedPaymentType))
      _checkoutService
          .saveSelectedPaymentType(_hiveDbService.cartRes!.resPaymentTypes![0]);
  }

  /// UPDATES deliveryDateTime
  void updateDateTimeForDelivery(DateTime? newDeliveryDateTime) {
    log.v('updateDateTimeForDelivery()');
    // var resWorkingHoursSplitted = cartRes!.workingHours!.split('-');
    // var resStartWorkingHoursSplitted = resWorkingHoursSplitted[0].split(':');
    // var resEndWorkingHoursSplitted = resWorkingHoursSplitted[1].split(':');
    // var startHour = int.parse(resStartWorkingHoursSplitted[0]);
    // var startMinute = int.parse(resStartWorkingHoursSplitted[1]);
    // var endHour = int.parse(resEndWorkingHoursSplitted[0]);
    // var endMinute = int.parse(resEndWorkingHoursSplitted[1]);
    // if ((deliveryDateTime!.hour < startHour ||
    //         deliveryDateTime!.minute < startMinute) ||
    //     (deliveryDateTime!.hour > endHour ||
    //         deliveryDateTime!.minute > endMinute))
    deliveryDateTime = newDeliveryDateTime;
    deliveryDateFormatted = DateFormat('HH:mm').format(deliveryDateTime!);
    notifyListeners();
  }

  /// SEARCHES and GETS promocode if FOUND
  Future<void> searchPromocode(String? searchText) async {
    log.i('searchPromocode() searchText: $searchText');
    if (searchText != null && searchText.isEmpty || searchText!.length < 3)
      return;

    try {
      _promocode = await runBusyFuture(
        _checkoutService.searchPromocode(searchText, getTotalCartSum.floor()),
        busyObject:
            searchText, // This makes it busy only for this view in a whole VM
      );
      log.v('CHECKOUT VM _promocode: $_promocode');
    } catch (err) {
      throw err;
    }
  }

  /// UPDATES _promocode
  void resetPromocode() {
    log.v('resetPromocode()');
    _promocode = null;
    notifyListeners();
  }

  /// GETS total cart meals sum with each price/discountPrice, vols price, customs price, and each cartMeal's quantity
  num get getTotalCartSum {
    num totalCartSum = 0;

    _hiveDbService.cartMeals.forEach((_cartMeal) {
      num _totalCartMealSum = 0;
      _totalCartMealSum += _cartMeal.discount != null || _cartMeal.discount! > 0
          ? _cartMeal.discountedPrice!
          : _cartMeal.price!;

      _cartMeal.volumes!.forEach((vol) {
        if (vol.id != -1) _totalCartMealSum += vol.price!;
      });
      _cartMeal.customs!.forEach((cus) {
        _totalCartMealSum += cus.price!;
      });

      _totalCartMealSum *= _cartMeal.quantity!;

      totalCartSum += _totalCartMealSum;
    });

    return totalCartSum;
  }

  /// GETS getPromocodePrice
  num get getPromocodePrice {
    num totalPromocodePrice = 0;

    if (promocode != null) {
      if (promocode!.promoType == 1)
        totalPromocodePrice = promocode!.discount!;
      else
        totalPromocodePrice = (getTotalCartSum / 100) * promocode!.discount!;
    }
    return totalPromocodePrice;
  }

  /// GETS getTotalCartSum with promocode
  num get getTotalCartSumWithPromocode {
    num totalCartSum = getTotalCartSum;

    if (promocode != null) {
      if (promocode!.promoType == 1)
        totalCartSum -= promocode!.discount!;
      else
        totalCartSum = getTotalCartSum - getPromocodePrice;
    }
    return totalCartSum;
  }

//------------------------ PAYMENT TYPE BOTTOM SHEET ----------------------------//

  // /// CALLS PaymentTypeBottomSheetView
  // Future<void> showCustomPaymentTypeBottomSheet() async {
  //   log.i('');
  //   await _bottomSheetService.showCustomSheet(
  //     variant: BottomSheetType.paymentType,
  //     enableDrag: true,
  //     barrierDismissible: true,
  //     isScrollControlled: true,
  //   );
  // }

  HiveResPaymentType? get selectedPaymentType =>
      _checkoutService.selectedPaymentType; // For CheckoutBottomSheetView

  HiveResPaymentType? _tempSelectedPaymentType;
  HiveResPaymentType? get tempSelectedPaymentType =>
      _tempSelectedPaymentType != null
          ? _tempSelectedPaymentType!
          : _checkoutService.selectedPaymentType;

  /// Temporarily SETS paymentType
  void updateTempSelectedPaymentType(HiveResPaymentType selectedPaymentType) {
    log.v(
        'updateTempSelectedPaymentType() selectedPaymentType with id: ${selectedPaymentType.id}');

    _tempSelectedPaymentType = selectedPaymentType;
    notifyListeners();
  }

  /// SAVES paymentType ( uses _checkoutService reactivity)
  void savePaymentType() {
    log.v(
        'savePaymentType() tempSelectedPaymentType: ${tempSelectedPaymentType!.id}');

    _checkoutService.saveSelectedPaymentType(tempSelectedPaymentType!);
    notifyListeners();
  }

//------------------------ SELECT ADDRESS BOTTOM SHEET ----------------------------//

  /// CALLS SelectAddressBottomSheet
  // Future<void> showCustomSelectAddressBottomSheet() async {
  //   log.i('');
  //   await _bottomSheetService.showCustomSheet(
  //     variant: BottomSheetType.selectAddress,
  //     enableDrag: true,
  //     barrierDismissible: true,
  //     isScrollControlled: true,
  //   );
  // }

//------------------------ CREATE ORDER PART ----------------------------//

  String? _checkoutNote = '';
  String? get checkoutNote => _checkoutNote;

  /// UPDATES _street
  String? updateCheckoutNote(String? value) {
    log.v('updateCheckoutNote value: $value');
    if (value == null || value.isEmpty) return null;

    _checkoutNote = value;
    notifyListeners();
    return null;
  }

  /// CREATES new order
  Future<void> createOrder({Function()? onFailForView}) async {
    log.v('createOrder()');
    await runBusyFuture(_checkoutService.createOrder(
      selectedAddress,
      deliveryDateTime,
      _promocode,
      _checkoutNote,
      () async {
        await _hiveDbService.clearCart();
        await _navService.pushNamedAndRemoveUntil(Routes.orderSuccessView);
      },
      () => onFailForView!(),
    ));
  }

  /// NAVIGATES to Orders by removing all previous routes
  Future<void> navToOrdersByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.ordersView);

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_checkoutService, _hiveDbService, _toggleButtonService];
}
