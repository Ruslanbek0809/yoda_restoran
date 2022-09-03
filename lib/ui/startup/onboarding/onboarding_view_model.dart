import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../utils/utils.dart';

class OnBoardingViewModel extends BaseViewModel {
  final log = getLogger('OnBoardingViewModel');

  final _navService = locator<NavigationService>();

//------------------------ SUCCESS NAV TO HOME ----------------------------//

  Future<void> successNavToHome() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Constants.isOnBoardingSeen, true);
    await _navService.replaceWith(Routes.homeView);
  }
}
