import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/services/services.dart';

import '../login_otp_view_model.dart';

class OtpViewModel extends LoginOtpViewModel {
  OtpViewModel() : super(successRoute: Routes.homeView);
  final _userApiService = locator<UserApiService>();

  @override
  Future<void> runLoginOtp() =>
      _userApiService.verifyUser(otpValue); // phoneValue is generated value

  void navigateBack() => navigationService.back();
}
