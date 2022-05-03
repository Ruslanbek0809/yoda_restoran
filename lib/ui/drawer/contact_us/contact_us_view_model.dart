import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/services/services.dart';

class ContactUsViewModel extends BaseViewModel {
  final log = getLogger('ContactUsViewModel');

  final _navService = locator<NavigationService>();
  final _userService = locator<UserService>();

  String? _name;
  String? get name => _name;

  String? _phone;
  String? get phone => _phone;

  String? _info;
  String? get info => _info;

  /// UPDATES _name
  String? updateName(String? value) {
    log.v('updateName value: $value');
    if (value!.isEmpty) {
      return LocaleKeys.your_name.tr();
    }

    _name = value;
    notifyListeners();
  }

  /// UPDATES _email
  String? updatePhone(String? value) {
    log.v('updatePhone value: $value');
    if (value == null || value.isEmpty || value.length < 11) {
      return LocaleKeys.enter_phone.tr();
    }

    _phone = value;
    notifyListeners();
  }

  /// UPDATES _info
  String? updateInfo(String? value) {
    log.v('updateInfo value: $value');
    if (value!.isEmpty) {
      return LocaleKeys.enter_text.tr();
    }

    _info = value;
    notifyListeners();
  }

  Future<void> onContactPressed({
    Function()? onFailForView,
    Function()? onSuccessForView,
  }) async {
    log.v('onContactPressed()');

    await runBusyFuture(_userService.contactUs(
      _name,
      _phone,
      _info,
      () async {
        _name = '';
        _phone = '';
        _info = '';
        onSuccessForView!();
      },
      () => onFailForView!(),
    ));
  }

//------------------------ NAVIGATIONS ----------------------------//

  void navBack() => _navService.back();

  /// NAVIGATES to Home by removing all previous routes
  Future<void> navToHomeByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.homeView);
}
