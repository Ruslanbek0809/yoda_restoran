import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/app/app.router.dart';
import '../../../app/app.locator.dart';
import '../../../services/services.dart';
import 'login_view.form.dart';

class LoginViewModel extends FormViewModel {
  final log = getLogger('LoginViewModel');
  final bool isCartView;
  LoginViewModel(this.isCartView);

  final _userService = locator<UserService>();
  final _navService = locator<NavigationService>();

  /// SAVES login data by posting data to login API (onFailForView() is used to show FlashBar ONLY)
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
