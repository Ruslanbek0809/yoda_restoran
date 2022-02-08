import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../services/services.dart';

class OtpViewModel extends FormViewModel {
  final log = getLogger('OtpViewModel');
  final bool isCartView;
  final String phone; // Needed for resend feature in OtpView
  OtpViewModel(this.isCartView, this.phone);

  final _userService = locator<UserService>();
  final _navService = locator<NavigationService>();
  final _apiRootService = locator<ApiRootService>();

  String? get successOtp => _userService.otp;

  int get durationTime => 59;

  bool _hideResendButton = true;
  bool get hideResendButton => _hideResendButton;

  String? _currentOtp = '';
  String? get currentOtp => _currentOtp;

  /// RESENDS otp code using phone number from previous LoginView
  Future<void> updateResentButton({Function()? onFailForView}) async {
    _hideResendButton = !_hideResendButton;
    log.i('_hideResendButton: $_hideResendButton, phone: $phone');
    await runBusyFuture(
      _userService.loginUser(
        phone: phone,
        onSuccess: () async {},
        onFail: () => onFailForView!(),
      ),
    );
    // notifyListeners();
  }

  /// SAVES otp data by posting otpCode to verify API
  Future saveOtpData({Function()? onFailForView}) async {
    await runBusyFuture(
      _userService.verifyUser(
        onSuccess: () async {
          _apiRootService.initDio(); // MUST REINITIALIZE whole app dio config
          /// Navigate to successful route
          isCartView
              ? _navService.popRepeated(2)
              : _navService.pushNamedAndRemoveUntil(Routes.homeView);
        },
        onFail: () {
          onFailForView!();
          // setValidationMessage(e.toString());
        },
      ),
    );
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
