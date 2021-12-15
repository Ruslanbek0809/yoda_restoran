import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/services/services.dart';
import 'package:yoda_res/ui/profile/login_otp_view_model.dart';

class LoginViewModel extends LoginOtpViewModel{
  
  LoginViewModel() : super(successRoute: Routes.homeView);
  final _userApiService = locator<UserApiService>();

  @override
  Future<void> runLoginOtp() {_userApiService.loginUser(phone)}

  void navigateBack() => navigationService.back();
}
