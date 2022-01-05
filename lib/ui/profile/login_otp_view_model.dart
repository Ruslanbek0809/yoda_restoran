import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../app/app.locator.dart';
import '../../app/app.logger.dart';

/// If this is commented below are LoginVM and OtpVM implementation with this
abstract class LoginOtpViewModel extends FormViewModel {
  final log = getLogger('LoginOtpViewModel');

  final navigationService = locator<NavigationService>();

  final String? successRoute;
  LoginOtpViewModel({@required this.successRoute});

  @override
  void setFormStatus() {}

  Future<void> runLoginOtp();

  Future saveData() async {
    try {
      await runBusyFuture(runLoginOtp(), throwException: true);

      // Navigate to successful route
      navigationService.replaceWith(successRoute!);
      // await _handleResponse(response);
    } catch (e) {
      log.e(e.toString());
      setValidationMessage(e.toString());
    }
  }

  // /// Checks if the result has an error. If it doesn't we navigate to the success view
  // /// else we show the friendly validation message.
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
}

// import '../../../app/app.locator.dart';
// import '../../../app/app.router.dart';
// import '../../../services/services.dart';
// import '../login_otp_view_model.dart';
// import 'login_view.form.dart';

// class LoginViewModel extends LoginOtpViewModel {
//   LoginViewModel() : super(successRoute: Routes.otpView);
//   final _userService = locator<UserService>();

//   @override
//   Future<void> runLoginOtp() =>
//       _userService.loginUser(phoneValue!); // phoneValue is generated value
// }

// import '../../../app/app.locator.dart';
// import '../../../app/app.logger.dart';
// import '../../../app/app.router.dart';
// import '../../../services/services.dart';
// import '../login_otp_view_model.dart';

// class OtpViewModel extends LoginOtpViewModel {
//   OtpViewModel() : super(successRoute: Routes.homeView);

//   final log = getLogger('OtpViewModel');

//   final _userService = locator<UserService>();

//   String? get successOtp => _userService.otp;

//   int get durationTime => 59;

//   bool _hideResendButton = true;
//   bool get hideResendButton => _hideResendButton;

//   String? _currentOtp = '';
//   String? get currentOtp => _currentOtp;

//   void updateResentButton() {
//     _hideResendButton = !_hideResendButton;
//     log.i('_hideResendButton: $_hideResendButton');
//     notifyListeners();
//   }

//   @override
//   Future<void> runLoginOtp() => _userService.verifyUser();
// }

