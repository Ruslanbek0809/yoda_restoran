import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../services/services.dart';
import '../../../utils/utils.dart';

class OtpViewModel extends FormViewModel {
  final log = getLogger('OtpViewModel');
  final bool isCartView;
  final String phone; // Needed for resend feature in OtpView
  OtpViewModel(this.isCartView, this.phone);

  final _userService = locator<UserService>();
  final _navService = locator<NavigationService>();
  final _apiRootService = locator<ApiRootService>();

  // String? get successOtp => _userService.otp;

  int get durationTime => 59;

  bool _hideResendButton = true;
  bool get hideResendButton => _hideResendButton;

  String? _currentOtp = '';
  String? get currentOtp => _currentOtp;

  //*UPDATES resend button
  Future<void> updateResendButton({Function()? onFailForView}) async {
    _hideResendButton = !_hideResendButton;
    log.i('_hideResendButton: $_hideResendButton, phone: $phone');
    notifyListeners();
  }

  //*RESENDS otp code using phone number from previous LoginView
  Future<void> updateResendButtonWithCode({Function()? onFailForView}) async {
    _hideResendButton = !_hideResendButton;
    log.i('_hideResendButton: $_hideResendButton, phone: $phone');
    await runBusyFuture(
      _userService.loginUser(
        phone: phone,
        onSuccess: () async {},
        onFail: () => onFailForView!(),
      ),
    );
  }

  //*SAVES otp data by posting otpCode to verify API
  Future verifyOtpCode(String currentOtp, {Function()? onFailForView}) async {
    await runBusyFuture(
      _userService.verifyUser(
        currentOtp,
        onSuccess: () async {
          log.i('onSuccess verifyUser: $_hideResendButton, phone: $phone');
          _apiRootService.initDio(); // MUST REINITIALIZE whole app dio config
          //*Navigate to successful route
          isCartView
              ? _navService.popRepeated(2)
              : _navService.pushNamedAndRemoveUntil(Routes.homeView);
        },
        onFail: () {
          log.i('onFail verifyUser: $_hideResendButton, phone: $phone');
          onFailForView!();
          // setValidationMessage(e.toString());
        },
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
