import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/ui/profile/otp/otp_view.form.dart';
import '../login_otp_view_model.dart';

class OtpViewModel extends LoginOtpViewModel {
  OtpViewModel() : super(successRoute: Routes.homeView);
  final _userApiService = locator<UserApiService>();
  String? get otp => _userApiService.otp;

  @override
  Future<void> runLoginOtp() =>
      _userApiService.verifyUser(otpValue!); // otpValue is generated value

  void navigateBack() => navigationService.back();
}
