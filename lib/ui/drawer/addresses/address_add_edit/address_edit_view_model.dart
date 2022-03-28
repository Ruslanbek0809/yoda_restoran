import 'package:easy_localization/easy_localization.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart' hide Trans;
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/services/services.dart';

import '../../../../models/models.dart';

class AddressEditViewModel extends BaseViewModel {
  final log = getLogger('AddressEditViewModel');
  final Address address;
  AddressEditViewModel({required this.address});

  final _userService = locator<UserService>();
  final _navService = locator<NavigationService>();

  String? _city;
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

  /// SETS initial address values for edit
  void setInitialAddress() {
    log.v('setInitialAddress address: $address');
    if (address.city == 'Aşgabat' || address.city == 'Ашхабад')
      _city = LocaleKeys.ashgabat.tr();
    _street = address.street;
    _apartment = address.apartment;
    _house = address.house;
    _floor = address.floor;
    _note = address.notes;
  }

  /// UPDATES _city
  String? updateCity(String? value) {
    log.v('updateCity value: $value');
    if (value!.isEmpty) return LocaleKeys.enterStreet.tr();

    _city = value;
    notifyListeners();
    return null;
  }

  /// UPDATES _street
  String? updateStreet(String? value) {
    log.v('updateStreet value: $value');
    if (value!.isEmpty) return LocaleKeys.enterStreet.tr();

    _street = value;
    notifyListeners();
    return null;
  }

  /// UPDATES _house
  String? updateHouse(String? value) {
    log.v('updateHouse value: $value');
    if (value == null || value.isEmpty) return null;

    _house = int.parse(value);
    notifyListeners();
    return null;
  }

  /// UPDATES _apartment
  String? updateApartment(String? value) {
    log.v('updateApartment value: $value');
    if (value == null || value.isEmpty) return null;

    _apartment = int.parse(value);
    notifyListeners();
    return null;
  }

  /// UPDATES _floor
  String? updateFloor(String? value) {
    log.v('updateFloor value: $value');
    if (value == null || value.isEmpty) return null;

    _floor = int.parse(value);
    notifyListeners();
    return null;
  }

  /// UPDATES _street
  String? updateNote(String? value) {
    log.v('updateNote value: $value');
    if (value == null || value.isEmpty) return null;

    _note = value;
    notifyListeners();
    return null;
  }

  /// EDITS selected address
  Future<void> onEditAddressPressed(
    Function()? onSuccess,
    Function()? onFail,
  ) async {
    log.v('onEditAddressPressed()');
    try {
      await runBusyFuture(_userService.editAddress(
        address.id,
        _city,
        _street,
        _house,
        _apartment,
        _floor,
        _note,
        () => onSuccess!(),
        () => onFail!(),
      ));
    } catch (err) {
      throw err;
    }
  }

//------------------------ NAVIGATION ----------------------------//
  void navBack() => _navService.back(result: true);
}
