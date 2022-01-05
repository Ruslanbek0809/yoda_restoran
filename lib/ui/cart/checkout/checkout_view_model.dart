import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/models/hive_models/hive_models.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';

class CheckoutViewModel extends ReactiveViewModel {
  final log = getLogger('CheckoutViewModel');

  final _checkoutService = locator<CheckoutService>();
  final _hiveDbService = locator<HiveDbService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _userService = locator<UserService>();
  final _navService = locator<NavigationService>();
  final _toggleButtonService = locator<ToggleButtonService>();

  HiveUser? get currentUser => _userService.currentUser;

  HiveRestaurant? get cartRes => _hiveDbService.cartRes;

  bool get isDelivery => _toggleButtonService.isDelivery;

  String get searchPromocodeText => _checkoutService.searchPromocodeText;

  Promocode? _promocode;
  Promocode? get promocode => _promocode;
  // Promocode? get promocode => _checkoutService.promocode;

  /// DateTime vars
  final now = DateTime.now().add(Duration(hours: 1));
  DateTime? tomorrow;
  DateTime? maxDateTime;
  DateTime? deliveryDateTime;
  String? deliveryDateFormatted = '';

  /// ASSIGNS default value for dateTime
  void getOnModelReady() {
    deliveryDateTime = now;
    tomorrow = DateTime(now.year, now.month, now.day + 1);
    maxDateTime = DateTime(now.year, now.month, now.day + 1, 20);
  }

  /// UPDATES deliveryDateTime
  void updateDateTimeForDelivery(DateTime? newDeliveryDateTime) {
    var resWorkingHoursSplitted = cartRes!.workingHours!.split('-');
    var resStartWorkingHoursSplitted = resWorkingHoursSplitted[0].split(':');
    var resEndWorkingHoursSplitted = resWorkingHoursSplitted[1].split(':');
    var startHour = int.parse(resStartWorkingHoursSplitted[0]);
    var startMinute = int.parse(resStartWorkingHoursSplitted[1]);
    var endHour = int.parse(resEndWorkingHoursSplitted[0]);
    var endMinute = int.parse(resEndWorkingHoursSplitted[1]);
    if ((deliveryDateTime!.hour < startHour ||
            deliveryDateTime!.minute < startMinute) ||
        (deliveryDateTime!.hour > endHour ||
            deliveryDateTime!.minute > endMinute))
      log.v('SHOW DATE TIME WRONG SNACKBAR'); // TODO: Add Snackbar
    deliveryDateTime = newDeliveryDateTime;
    deliveryDateFormatted = DateFormat('HH:mm').format(deliveryDateTime!);
    notifyListeners();
  }

  /// SEARCHES and GETS promocode if FOUND
  Future<void> searchPromocode(String? searchText) async {
    log.i('searchPromocode() searchText: $searchText');
    if (searchText != null && searchText.isEmpty || searchText!.length < 2)
      return;

    try {
      _promocode =
          await runBusyFuture(_checkoutService.searchPromocode(searchText));
      log.v('CHECKOUT VM _promocode: $_promocode');
    } catch (err) {
      throw err;
    }
  }

  /// GETS total cart meals sum with each price/discountPrice, vols price, customs price, and each cartMeal's quantity
  num get getTotalCartSum {
    num totalCartSum = 0;

    _hiveDbService.cartMeals.forEach((_cartMeal) {
      totalCartSum += _cartMeal.discount != null || _cartMeal.discount! > 0
          ? _cartMeal.discountedPrice!
          : _cartMeal.price!;

      _cartMeal.volumes!.forEach((vol) {
        if (vol.id != -1) totalCartSum += vol.price!;
      });
      _cartMeal.customs!.forEach((cus) {
        totalCartSum += cus.price!;
      });

      totalCartSum *= _cartMeal.quantity!;
    });

    return totalCartSum;
  }

  /// GETS getTotalCartSum with promocode
  num get getTotalCartSumWithPromocode {
    num totalCartSum = getTotalCartSum;

    if (promocode != null) {
      if (promocode!.promoType == 1)
        totalCartSum -= promocode!.discount!;
      else
        totalCartSum = (totalCartSum / 100) * promocode!.discount!;
    }
    return totalCartSum;
  }

  /// GETS getPromocodePrice
  num get getPromocodePrice {
    num totalPromocodePrice = 0;

    if (promocode != null) {
      if (promocode!.promoType == 1)
        totalPromocodePrice = promocode!.discount!;
      else
        totalPromocodePrice = getTotalCartSum - getTotalCartSumWithPromocode;
    }
    return totalPromocodePrice;
  }

//------------------------ PAYMENT TYPE BOTTOM SHEET ----------------------------//

  /// CALLS PaymentTypeBottomSheetView
  Future<void> showCustomPaymentTypeBottomSheet() async {
    log.i('');
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.paymentType,
      enableDrag: true,
      barrierDismissible: true,
      isScrollControlled: true,
    );
  }

  PaymentType? get selectedPaymentType =>
      _checkoutService.selectedPaymentType; // For CheckoutBottomSheetView

  PaymentType? _tempSelectedPaymentType;
  PaymentType get tempSelectedPaymentType => _tempSelectedPaymentType != null
      ? _tempSelectedPaymentType!
      : _checkoutService.selectedPaymentType!;

  /// Temporarily SETS paymentType
  void updateTempSelectedPaymentType(PaymentType selectedPaymentType) {
    log.v(
        'updateTempSelectedPaymentType selectedPaymentType: ${selectedPaymentType.name}');

    _tempSelectedPaymentType = selectedPaymentType;
    notifyListeners();
  }

  /// SAVES paymentType ( uses _checkoutService reactivity)
  void savePaymentType() {
    log.v(
        'updatePaymentType() tempSelectedPaymentType: ${tempSelectedPaymentType.name}');

    _checkoutService.savesPaymentType(tempSelectedPaymentType);
    notifyListeners();
  }

//------------------------ SELECT ADDRESS BOTTOM SHEET ----------------------------//

  /// CALLS SelectAddressBottomSheet
  Future<void> showCustomSelectAddressBottomSheet() async {
    log.i('');
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.selectAddress,
      enableDrag: true,
      barrierDismissible: true,
      isScrollControlled: true,
    );
  }

  List<Address>? get addresses => _checkoutService.addresses;

  Address? get selectedAddress =>
      _checkoutService.selectedAddress; // For CheckoutBottomSheetView

  Address? _tempSelectedAddress;
  Address? get tempSelectedAddress => _tempSelectedAddress != null
      ? _tempSelectedAddress!
      : _checkoutService.selectedAddress!;

  /// SEARCHES and GETS promocode if found
  Future<void> getAddresses() async {
    log.i('getAddresses()');

    try {
      await runBusyFuture(_checkoutService.getAddresses());
    } catch (err) {
      throw err;
    }
  }

  /// Temporarily SETS _tempSelectedAddress
  void updateTempSelectedAddress(Address selectedAddress) {
    log.v(
        'updateTempSelectedAddress selectedAddress: ${selectedAddress.street}');

    _tempSelectedAddress = selectedAddress;
    notifyListeners();
  }

  /// SAVES selectedAddress ( uses _checkoutService reactivity)
  void saveSelectedAddress() {
    log.v(
        'saveSelectedAddress() _tempSelectedAddress: ${_tempSelectedAddress!.street}');

    _checkoutService.saveSelectedAddress(_tempSelectedAddress!);
    notifyListeners();
  }

//------------------------ ADD ADDRESS BOTTOM SHEET ----------------------------//

  /// CALLS AddAddressBottomSheet
  Future<void> showCustomAddAddressBottomSheet() async {
    log.i('');
    await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.addAddress,
      enableDrag: true,
      barrierDismissible: true,
      isScrollControlled: true,
    );
  }

  String? _city = 'Aşgabat';
  String? get city => _city;

  String? _street;
  String? get street => _street;

  int? _apartment;
  int? get apartment => _apartment;

  int? _house;
  int? get house => _house;

  int? _floor;
  int? get floor => _floor;

  String? _note;
  String? get note => _note;

  /// UPDATES _street
  String? updateStreet(String? value) {
    log.v('updateStreet value: $value');
    if (value!.isEmpty) {
      return 'Köçäni giriziň';
    }

    _street = value;
    notifyListeners();
  }

  /// UPDATES _house
  String? updateHouse(String? value) {
    log.v('updateHouse value: $value');
    if (value == null || value.isEmpty) return null;

    _house = int.parse(value);
    notifyListeners();
  }

  /// UPDATES _apartment
  String? updateApartment(String? value) {
    log.v('updateApartment value: $value');
    if (value == null || value.isEmpty) return null;

    _apartment = int.parse(value);
    notifyListeners();
  }

  /// UPDATES _floor
  String? updateFloor(String? value) {
    log.v('updateFloor value: $value');
    if (value == null || value.isEmpty) return null;

    _floor = int.parse(value);
    notifyListeners();
  }

  /// UPDATES _street
  String? updateNote(String? value) {
    log.v('updateNote value: $value');
    if (value == null || value.isEmpty) return null;

    _note = value;
    notifyListeners();
  }

  /// ADDS new address
  Future<void> onAddAddressPressed() async {
    log.v('onAddAddressPressed()');
    try {
      await runBusyFuture(_checkoutService.addAddress(
          _city, _street, _house, _apartment, _floor, _note));
    } catch (err) {
      throw err;
    }
  }

//------------------------ CREATE ORDER PART ----------------------------//

  String? _checkoutNote = '';
  String? get checkoutNote => _checkoutNote;

  /// UPDATES _street
  String? updateCheckoutNote(String? value) {
    log.v('updateCheckoutNote value: $value');
    if (value == null || value.isEmpty) return null;

    _checkoutNote = value;
    notifyListeners();
  }

  /// CREATES new order
  Future<void> createOrder() async {
    log.v('createOrder()');
    var resultSuccess = await runBusyFuture(_checkoutService.createOrder(
      selectedAddress,
      deliveryDateTime,
      _promocode,
      _checkoutNote,
    ));
    if (resultSuccess) {
      await _hiveDbService.clearCart();
      log.i(
          '_hiveDbService.cartMeals length: ${_hiveDbService.cartMeals.length}');
      _navService.pushNamedAndRemoveUntil(Routes.orderSuccessView);
    }
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_checkoutService, _hiveDbService];
}
