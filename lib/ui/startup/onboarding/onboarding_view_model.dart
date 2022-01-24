import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/app/app.locator.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/app/app.router.dart';
import 'package:yoda_res/utils/utils.dart';

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
