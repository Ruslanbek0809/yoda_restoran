import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../services/services.dart';
import '../login_otp_view_model.dart';
import 'login_view.form.dart';

class LoginViewModel extends LoginOtpViewModel {
  LoginViewModel() : super(successRoute: Routes.otpView);
  final _userService = locator<UserService>();

  @override
  Future<void> runLoginOtp() =>
      _userService.loginUser(phoneValue!); // phoneValue is generated value
}
