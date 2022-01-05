import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../services/services.dart';

class OtpViewModel extends FormViewModel {
  final log = getLogger('OtpViewModel');
  final bool isCartView;
  OtpViewModel(this.isCartView);

  final _userService = locator<UserService>();
  final _navService = locator<NavigationService>();

  String? get successOtp => _userService.otp;

  int get durationTime => 59;

  bool _hideResendButton = true;
  bool get hideResendButton => _hideResendButton;

  String? _currentOtp = '';
  String? get currentOtp => _currentOtp;

  void updateResentButton() {
    _hideResendButton = !_hideResendButton;
    log.i('_hideResendButton: $_hideResendButton');
    notifyListeners();
  }

  /// SAVES otp data by posting otpCode to verify API
  Future saveOtpData() async {
    try {
      await runBusyFuture(_userService.verifyUser(), throwException: true);

      // Navigate to successful route
      _navService.replaceWith(isCartView ? Routes.cartView : Routes.homeView);
      // await _handleResponse(response);
    } catch (e) {
      log.e(e.toString());
      setValidationMessage(e.toString());
    }
  }

  @override
  void setFormStatus() {}

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
