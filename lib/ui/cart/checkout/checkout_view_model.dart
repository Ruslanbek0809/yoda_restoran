import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
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

  HiveUser? get currentUser => _userService.currentUser;

  Promocode? get promocode => _checkoutService.promocode;

  /// DateTime vars
  final now = DateTime.now();
  DateTime? tomorrow;
  DateTime? maxDateTime;
  DateTime? deliverDateTime;
  String? deliverDateFormatted = '';

  void getOnModelReady() {
    deliverDateTime = now;
    tomorrow = DateTime(now.year, now.month, now.day + 1);
    maxDateTime = DateTime(now.year, now.month, now.day + 1, 20);
  }

  /// SEARCHES and GETS promocode if found
  Future<void> searchPromocode(String? searchText) async {
    log.i('searchPromocode() searchText: $searchText');
    if (searchText != null && searchText.isEmpty || searchText!.length < 2)
      return;

    try {
      await runBusyFuture(_checkoutService.searchPromocode(searchText));
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

  Future<void> onAddAddressPressed() async {
    log.v('onAddAddressPressed()');
    try {
      await runBusyFuture(_checkoutService.addAddress(
          _city, _street, _house, _apartment, _floor, _note));
    } catch (err) {
      throw err;
    }
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_checkoutService];
}
