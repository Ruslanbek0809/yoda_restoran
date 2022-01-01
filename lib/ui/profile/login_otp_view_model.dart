import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../app/app.locator.dart';
import '../../app/app.logger.dart';

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

  /// Checks if the result has an error. If it doesn't we navigate to the success view
  /// else we show the friendly validation message.
  Future<void> _handleResponse(Response result) async {
    log.v('');

    // Check result
    if (!result.hasError) {
      // Navigate to successful route
      navigationService.replaceWith(successRoute!);
    } else {
      log.w('Login Failed: ${result.body}');

      setValidationMessage(result.body);
      notifyListeners();
    }
  }
}
