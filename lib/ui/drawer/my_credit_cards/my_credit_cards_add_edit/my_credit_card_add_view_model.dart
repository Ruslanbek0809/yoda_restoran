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
    // if (value == null || value.isEmpty) return null;
    if (value!.isEmpty) return LocaleKeys.enterStreet.tr();

    _street = value;
    notifyListeners();
    return null;
  }

  // /// ADDS new address
  // Future<void> onAddAddressPressed(
  //   Function()? onSuccess,
  //   Function()? onFail,
  // ) async {
  //   log.v('onAddAddressPressed()');
  //   try {
  //     await runBusyFuture(_userService.addAddress(
  //       city,
  //       street,
  //       house,
  //       apartment,
  //       floor,
  //       note,
  //       () => onSuccess!(),
  //       () => onFail!(),
  //     ));
  //   } catch (err) {
  //     throw err;
  //   }
  // }

//------------------------ NAVIGATION ----------------------------//
  void navBack() => _navService.back(result: true);

  void navBackWithFalse() => _navService.back(result: false);
}
