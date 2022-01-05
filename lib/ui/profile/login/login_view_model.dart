import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/app/app.router.dart';
import '../../../app/app.locator.dart';
import '../../../services/services.dart';
import 'login_view.form.dart';

class LoginViewModel extends FormViewModel {
  final log = getLogger('LoginViewModel');

  final _userService = locator<UserService>();
  final _navService = locator<NavigationService>();

  Future saveLoginData() async {
    try {
      await runBusyFuture(_userService.loginUser(phoneValue!),
          throwException: true);

      // Navigate to successful route
      _navService.replaceWith(Routes.otpView);
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
