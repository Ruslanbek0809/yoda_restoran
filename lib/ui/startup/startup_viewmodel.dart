import 'package:firebase_core/firebase_core.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../app/app.locator.dart';
import '../../app/app.logger.dart';
import '../../app/app.router.dart';
import '../../services/services.dart';

class StartUpViewModel extends BaseViewModel {
  final log = getLogger('StartUpViewModel');
  final _apiRootService = locator<ApiRootService>();
  final _navService = locator<NavigationService>();
  final _pushNotificationService = locator<PushNotificationService>();
  final _hiveDbService = locator<HiveDbService>();
  final _userService = locator<UserService>();

  Future<void> runStartupLogic() async {
    log.i('===== StartUpViewModel STARTED =====');

    /// FIREBASE initialization. This second Firebase.initializeApp() is used to initialize Firebase again in case network is down
    await Firebase.initializeApp()
        .then((value) => _pushNotificationService.initialise());

    await _apiRootService.initDio();
    await _hiveDbService.initDB();
    await _userService.initUser();

    _hiveDbService.getCartMeals(); // GETS all CART meals inside cartMealBox
    _hiveDbService.getCartRes(); // GETS CART restaurant inside cartResBox

    /// NAV next View based on condition
    if (_userService.hasLoggedInUser) {
      log.v(
          'USER FOUND: ${_userService.currentUser!.mobile}, ${_userService.currentUser!.accessToken}');
      _navService.replaceWith(Routes.homeView);
    } else {
      log.v('USER NOTTTTT FOUND');
      _navService.replaceWith(Routes.loginView);
    }

    log.i('===== StartUpViewModel ENDED =====');
  }
}
