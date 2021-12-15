import 'package:stacked/stacked.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/ui/profile/login_otp_view_model.dart';

class LoginViewModel extends LoginOtpViewModel {
  LoginViewModel() : super(successRoute: Routes.homeView);

  final _userApiService = locator<UserApiService>();

  @override
  Future<void> runLoginOtp(String phone) {
    return 
  }
  // @override
  // Future runLoginOtp() =>
  //     _firebaseAuthenticationService.loginWithEmail(
  //       email: emailValue,
  //       password: passwordValue,
  //     );

  void navigateBack() => navigationService.back();
}
