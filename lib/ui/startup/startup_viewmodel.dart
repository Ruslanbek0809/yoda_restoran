import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flash/flash.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    _hiveDbService.getCartMeals(); // GETS all CART meals inside cartMealBox
    _hiveDbService.getCartRes(); // GETS CART restaurant inside cartResBox

    /// USER part. GETS initial user with condition and behaves with that in mind
    await _userService.getInitialUser(
      onSuccess: () async {
        log.v('==== SUCCESS User ====');

        Platform.isIOS
            ? await _navService.replaceWithTransition(
                HomeView(),
                transition: NavigationTransition.Fade,
              )
            : await _navService.replaceWith(Routes.homeView);
      },
      onFail: () async {
        log.v('====== FAIL User ======');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? _accessToken = prefs.getString(Constants.accessToken);
        if (_accessToken != null) {
          await prefs.remove(Constants.accessToken);
          _accessToken = prefs.getString(Constants.accessToken);
          log.i('ACCESS TOKEN after remove: $_accessToken');
        }
        await _userService.clearUser();

        Platform.isIOS
            ? await _navService.replaceWithTransition(
                HomeView(),
                transition: NavigationTransition.Fade,
              )
            : await _navService.replaceWith(Routes.homeView);
      },
    );
  }

  @override
  Stream<ConnectivityStatus> get stream =>
      _connectivityService.connectionStatusController.stream;
}
