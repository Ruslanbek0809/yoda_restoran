import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';

abstract class LoginOtpViewModel extends FormViewModel {
  final navigationService = locator<NavigationService>();

  final String? successRoute;
  LoginOtpViewModel({@required this.successRoute});

  @override
  void setFormStatus() {}

  Future saveData() async {
    // Run loginOtp and set viewmodel to busy
    final result = await runBusyFuture(runLoginOtp());

    // Check result
    if (!result.hasError) {
      // Navigate to successful route
      navigationService.replaceWith(successRoute!);
    } else {
      // set validation message if we have an error
      setValidationMessage(result.errorMessage); // this gives validationMessage
    }
  }

  Future runLoginOtp();
}
