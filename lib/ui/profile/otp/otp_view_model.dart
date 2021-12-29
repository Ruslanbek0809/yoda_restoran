import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/services/services.dart';
import '../login_otp_view_model.dart';

class OtpViewModel extends LoginOtpViewModel {
  OtpViewModel() : super(successRoute: Routes.homeView);

  final log = getLogger('OtpViewModel');

  final _userService = locator<UserService>();

  String? get successOtp => _userService.otp;

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

  @override
  Future<void> runLoginOtp() => _userService.verifyUser();
}
