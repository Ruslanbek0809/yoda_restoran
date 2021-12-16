import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/services/services.dart';
import '../login_otp_view_model.dart';

class OtpViewModel extends LoginOtpViewModel {
  OtpViewModel() : super(successRoute: Routes.homeView);

  final log = getLogger('OtpViewModel');

  final _userApiService = locator<UserApiService>();

  String? get successOtp => _userApiService.otp;

  int get durationTime => 59;

  bool _hideResendButton = true;
  bool get hideResendButton => _hideResendButton;

  String? _currentOtp = '';
  String? get currentOtp => _currentOtp;

  void updateResentButton() {
    _hideResendButton = !_hideResendButton;
    log.i('_hideResendButton: $_hideResendButton');
    notifyListeners();
  }

  void updateOtp(String? otp) {
    _currentOtp = otp;
    log.i('_currentOtp: $_currentOtp');
  }

  @override
  Future<void> runLoginOtp() => _userApiService.verifyUser(_currentOtp!);

  void navigateBack() => navigationService.back();
}
