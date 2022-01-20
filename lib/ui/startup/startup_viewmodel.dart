import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flash/flash.dart';
import 'package:keyboard_actions/external/platform_check/platform_check.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/ui/home/home_view.dart';
import 'package:yoda_res/utils/utils.dart';
import '../../app/app.locator.dart';
import '../../app/app.logger.dart';
import '../../app/app.router.dart';
import '../../services/services.dart';

class StartUpViewModel extends StreamViewModel<ConnectivityStatus> {
  final log = getLogger('StartUpViewModel');

  final _apiRootService = locator<ApiRootService>();
  final _navService = locator<NavigationService>();
  final _pushNotificationService = locator<PushNotificationService>();
  final _hiveDbService = locator<HiveDbService>();
  final _userService = locator<UserService>();
  final _connectivityService = locator<ConnectivityService>();

  ConnectivityStatus? get connectivityStatus => data;

  FlashController<Object?>? flashController;

  bool _startAnimation = true;
  bool get startAnimation => _startAnimation;

  bool _startCircleAnimation = false;
  bool get startCircleAnimation => _startCircleAnimation;

  Future<void> runStartupLogic() async {
    log.i('===== runStartupLogic() STARTED =====');
    _startCircleAnimation = true;
    notifyListeners();

    await Future.delayed(Duration(milliseconds: 3300)).then((value) {
      _startAnimation = false;
      notifyListeners();
    });

    log.i('===== runStartupLogic() ENDED =====');
  }

  Future<void> navToHomeWithConnection() async {
    log.i('===== navToHomeWithConnection() STARTED =====');

    await flashController?.dismiss(); // DISMISSES no internet flashbar

    /// FIREBASE initialization. This second Firebase.initializeApp() is used to initialize Firebase again in case network is down
    await Firebase.initializeApp()
        .then((value) => _pushNotificationService.initialise());

    await _apiRootService.initDio();
    await _hiveDbService.initDB();
    await _userService.initUser();

    _hiveDbService.getCartMeals(); // GETS all CART meals inside cartMealBox
    _hiveDbService.getCartRes(); // GETS CART restaurant inside cartResBox

    log.i('===== navToHomeWithConnection() ENDED =====');
    Platform.isIOS
        ? await _navService.replaceWithTransition(
            HomeView(),
            transition: NavigationTransition.Fade,
          )
        : await _navService.replaceWith(Routes.homeView);
  }

  @override
  Stream<ConnectivityStatus> get stream =>
      _connectivityService.connectionStatusController.stream;
}
