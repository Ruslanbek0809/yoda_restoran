import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../app/app.locator.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';
import 'login_view.form.dart';

class LoginViewModel extends FormViewModel {
  final log = getLogger('LoginViewModel');
  final bool isCartView;
  LoginViewModel(this.isCartView);

  final _userService = locator<UserService>();
  final _navService = locator<NavigationService>();

  //*SAVES login data by posting data to login API (onFailForView() is used to show FlashBar ONLY)
  Future saveLoginData({Function()? onFailForView}) async {
    await runBusyFuture(
      _userService.loginUser(
        phone: phoneValue,
        onSuccess: () async {
          // Navigate to successful route
          await _navService.navigateTo(
            Routes.otpView,
            arguments: OtpViewArguments(
              isCartView: isCartView,
              phone: phoneValue!, // Needed for resend feature in OtpView
            ),
          );
        },
        onFail: () => onFailForView!(),
      ),
    );
  }

  @override
  void setFormStatus() {}

  // //*Checks if the result has an error. If it doesn't we navigate to the success view
  // //*else we show the friendly validation message.
  // Future<void> _handleResponse(Response result) async {
  //   log.v('');

  //   // Check result
  //   if (!result.hasError) {
  //     // Navigate to successful route
  //     navigationService.replaceWith(successRoute!);
  //   } else {
  //     log.w('Login Failed: ${result.body}');

  //     setValidationMessage(result.body);
  //     notifyListeners();
  //   }
  // }

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
        left: 0.1.sw,
        right: 0.1.sw,
        bottom: 0.05.sh,
      ),
    );
  }
}
