import 'package:easy_localization/easy_localization.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart' hide Trans;
import '../../../../app/app.locator.dart';
import '../../../../app/app.logger.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../services/services.dart';

class MyCreditCardAddViewModel extends BaseViewModel {
  final log = getLogger('MyCreditCardAddViewModel');

  final _userService = locator<UserService>();
  final _navService = locator<NavigationService>();

  String? _city = LocaleKeys.ashgabat.tr();
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

  /// UPDATES _city
  String? updateCity(String? value) {
    log.v('updateCity value: $value');
    if (value!.isEmpty) return LocaleKeys.enterCity.tr();

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

  /// ADDS new address
  Future<void> onAddAddressPressed(
    Function()? onSuccess,
    Function()? onFail,
  ) async {
    log.v('onAddAddressPressed()');
    try {
      await runBusyFuture(_userService.addAddress(
        city,
        street,
        house,
        apartment,
        floor,
        note,
        () => onSuccess!(),
        () => onFail!(),
      ));
    } catch (err) {
      throw err;
    }
  }

//------------------------ NAVIGATION ----------------------------//
  void navBack() => _navService.back(result: true);

  void navBackWithFalse() => _navService.back(result: false);
}
