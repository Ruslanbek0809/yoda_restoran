import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flash/flash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/ui/home/home_view.dart';
import 'package:yoda_res/ui/startup/onboarding/onboarding_view.dart';
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
  final _geolocatorService = locator<GeolocatorService>();
  final _dynamicLinkService = locator<DynamicLinkService>();

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

  Future<void> navToHomeWithConnection(Locale initLocale) async {
    log.i('===== navToHomeWithConnection() STARTED =====');

    await flashController?.dismiss(); // DISMISSES no internet flashbar

    /// So this below condition is to change lang of API initialization to ru lang when app is opened for the first time. Drawback of easy_localization. Workaround
    if (initLocale.toString() == 'ru_RU') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final _savedLocale = prefs.getString(Constants.savedLocale) ??
          'en_US'; // GETS saved locale.

      if (_savedLocale != 'ru_RU')
        await prefs.setString(Constants.savedLocale, initLocale.toString());
    }

    /// FIREBASE initialization. This second Firebase.initializeApp() is used to initialize Firebase again in case network is down
    await Firebase.initializeApp().then((value) {
      _pushNotificationService
          .initialise(); // INITIALIZATION of FB Push notification
      _dynamicLinkService
          .handleDynamicLinks(); // INITIALIZATION of FB Dynamic Link
    });

    /// GETS user's location
    await _geolocatorService.getUserLocation();

    await _apiRootService.initDio();
    await _hiveDbService.initDB();
    _hiveDbService.getCartMeals(); // GETS all CART meals inside cartMealBox
    _hiveDbService.getCartRes(); // GETS CART restaurant inside cartResBox

    /// CHECKS whether onBoarding was SEEN or NOT
    var prefs = await SharedPreferences.getInstance();
    var _isOnBoardingSeen = prefs.getBool(Constants.isOnBoardingSeen) ?? false;
    log.v('==== IS ONBOARDING SEEN: $_isOnBoardingSeen ====');

    /// USER part. GETS initial user with condition and behaves with that in mind
    await _userService.getInitialUser(
      onSuccess: () async {
        log.v('==== SUCCESS User ====');

        if (_isOnBoardingSeen) {
          Platform.isIOS
              ? await _navService.replaceWithTransition(
                  HomeView(),
                  transition: NavigationTransition.Fade,
                )
              : await _navService.replaceWith(Routes.homeView);
        } else {
          Platform.isIOS
              ? await _navService.replaceWithTransition(
                  OnBoardingView(),
                  transition: NavigationTransition.Fade,
                )
              : await _navService.replaceWith(Routes.onBoardingView);
        }
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

        if (_isOnBoardingSeen) {
          Platform.isIOS
              ? await _navService.replaceWithTransition(
                  HomeView(),
                  transition: NavigationTransition.Fade,
                )
              : await _navService.replaceWith(Routes.homeView);
        } else {
          Platform.isIOS
              ? await _navService.replaceWithTransition(
                  OnBoardingView(),
                  transition: NavigationTransition.Fade,
                )
              : await _navService.replaceWith(Routes.onBoardingView);
        }
      },
    );
  }

  @override
  Stream<ConnectivityStatus> get stream =>
      _connectivityService.connectionStatusController.stream;
}
