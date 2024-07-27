import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import 'package:stacked_services/stacked_services.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';

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

  //*UPDATES _name
  String? updateName(String? value) {
    log.v('updateName value: $value');
    if (value!.isEmpty) {
      return LocaleKeys.your_name.tr();
    }

    _name = value;
    notifyListeners();
    return null;
  }

  //*UPDATES _email
  String? updatePhone(String? value) {
    log.v('updatePhone value: $value');
    if (value == null || value.isEmpty || value.length < 11) {
      return LocaleKeys.enter_phone.tr();
    }

    _phone = value;
    notifyListeners();
    return null;
  }

  //*UPDATES _info
  String? updateInfo(String? value) {
    log.v('updateInfo value: $value');
    if (value!.isEmpty) {
      return LocaleKeys.enter_text.tr();
    }

    _info = value;
    notifyListeners();
    return null;
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
        left: 16.w,
        right: 16.w,
        bottom: 0.025.sh,
      ),
    );
  }

//*----------------------- NAVIGATIONS ----------------------------//

  void navBack() => _navService.back();

  //*NAVIGATES to Home by removing all previous routes
  Future<void> navToHomeByRemovingAll() async =>
      await _navService.pushNamedAndRemoveUntil(Routes.homeView);
}
