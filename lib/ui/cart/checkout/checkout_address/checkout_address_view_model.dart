import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/models/models.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/utils/utils.dart';

class CheckoutAddressViewModel extends FutureViewModel {
  final log = getLogger('CheckoutAddressViewModel');

  final _checkoutService = locator<CheckoutService>();
  final _bottomSheetService = locator<BottomSheetService>();

//------------------------ SELECT ADDRESS BOTTOM SHEET ----------------------------//

  List<Address>? get addresses => _checkoutService.addresses;

  Address? _tempSelectedAddress;
  Address? get tempSelectedAddress => _tempSelectedAddress != null
      ? _tempSelectedAddress!
      : _checkoutService.selectedAddress!;

  // /// SEARCHES and GETS promocode if found
  // Future<void> getAddresses() async {
  //   log.i('getAddresses()');

  //   try {
  //     await runBusyFuture(_checkoutService.getAddresses());
  //   } catch (err) {
  //     throw err;
  //   }
  // }

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

  @override
  Future futureToRun() => _checkoutService.getAddresses();

//------------------------ ADD ADDRESS BOTTOM SHEET ----------------------------//

  /// CALLS AddAddressBottomSheet
  Future<void> showCustomAddAddressBottomSheet() async {
    log.i('');
    SheetResponse<bool>? _navResult;
    _navResult = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.addAddress,
      enableDrag: true,
      barrierDismissible: true,
      isScrollControlled: true,
    );

    if (_navResult != null && _navResult.data == true) {
      log.v('Added and response: ${_navResult.data}');
      await initialise(); // Workaround
    }
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

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_checkoutService];
}
