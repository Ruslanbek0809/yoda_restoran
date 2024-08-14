import 'dart:io';
import 'dart:ui';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/services/sentry/sentry_module.dart';

import '../../app/app.locator.dart';
import '../../app/app.logger.dart';
import '../../app/app.router.dart';
import '../../services/services.dart';
import '../../utils/utils.dart';
import '../home/home_view.dart';
import 'onboarding/onboarding_view.dart';

class StartUpViewModel extends StreamViewModel<ConnectivityStatus> {
  final log = getLogger('StartUpViewModel');

  final _apiRootService = locator<ApiRootService>();
  final _navService = locator<NavigationService>();
  final _pushNotificationService = locator<PushNotificationService>();
  final _hiveDbService = locator<HiveDbService>();
  final _userService = locator<UserService>();
  final _connectivityService = locator<ConnectivityService>();
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

  bool checkAndHandleConnectivity(Locale initLocale) {
    if (connectivityStatus == ConnectivityStatus.Offline ||
        connectivityStatus == null) {
      //* Return true if offline, so that the view can show the flash message
      return true;
    } else {
      navToHomeWithConnection(initLocale);
      return false;
    }
  }

  Future<void> navToHomeWithConnection(Locale initLocale) async {
    log.i('===== navToHomeWithConnection() STARTED =====');

    try {
      if (initLocale.toString() == 'ru_RU') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final _savedLocale = prefs.getString(Constants.savedLocale) ?? 'en_US';
        if (_savedLocale != 'ru_RU') {
          await prefs.setString(Constants.savedLocale, initLocale.toString());
        }
      }

      await initializePushNotificationService();
      await initializeDynamicLinkService();
      await initializeAPIRootService();
      await initializeHiveDBService();
      await initializeUserService();

      navigateBasedOnOnBoardingStatus();
    } catch (e, stackTrace) {
      log.e('Error during startup: $e');
      reportExceptionToSentryWithStacktrace(
        e,
        additionalInfo: 'Startup process error',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> initializePushNotificationService() async {
    try {
      await _pushNotificationService.initialize();
    } catch (e, stackTrace) {
      log.e('Error initializing PushNotificationService', e);
      reportExceptionToSentryWithStacktrace(
        e,
        additionalInfo: 'PushNotificationService initialization',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> initializeDynamicLinkService() async {
    try {
      await _dynamicLinkService.handleBFDynamicLinks();
    } catch (e, stackTrace) {
      log.e('Error initializing DynamicLinkService', e);
      reportExceptionToSentryWithStacktrace(
        e,
        additionalInfo: 'DynamicLinkService initialization',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> initializeAPIRootService() async {
    try {
      await _apiRootService.initDio();
    } catch (e, stackTrace) {
      log.e('Error initializing API root service', e);
      reportExceptionToSentryWithStacktrace(
        e,
        additionalInfo: 'API root service initialization',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> initializeHiveDBService() async {
    try {
      await _hiveDbService.initHiveBoxes();
      _hiveDbService.getCartMeals();
      _hiveDbService.getCartRes();
      _hiveDbService.getHiveRatings();
      _hiveDbService.getHiveCreditCards();
      await _hiveDbService.cleanStoriesBasedOnDeadlines();
    } catch (e, stackTrace) {
      log.e('Error initializing Hive DB service', e);
      reportExceptionToSentryWithStacktrace(
        e,
        additionalInfo: 'Hive DB service initialization',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> initializeUserService() async {
    try {
      await _userService.initUser();
    } catch (e, stackTrace) {
      log.e('Error initializing user service', e);
      reportExceptionToSentryWithStacktrace(
        e,
        additionalInfo: 'User service initialization',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> navigateBasedOnOnBoardingStatus() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var _isOnBoardingSeen =
          prefs.getBool(Constants.isOnBoardingSeen) ?? false;
      log.v('==== IS ONBOARDING SEEN: $_isOnBoardingSeen ====');

      if (_isOnBoardingSeen) {
        Platform.isIOS
            ? await _navService.replaceWithTransition(
                HomeView(),
                transitionStyle: Transition.fade,
              )
            : await _navService.replaceWith(Routes.homeView);
      } else {
        Platform.isIOS
            ? await _navService.replaceWithTransition(
                OnBoardingView(),
                transitionStyle: Transition.fade,
              )
            : await _navService.replaceWith(Routes.onBoardingView);
      }
    } catch (e, stackTrace) {
      log.e('Error during navigation based on onboarding status', e);
      reportExceptionToSentryWithStacktrace(
        e,
        additionalInfo: 'Navigation based on onboarding status',
        stackTrace: stackTrace,
      );
    }
  }

  // //*USER part. GETS initial user with condition and behaves with that in mind
  // await _userService.getInitialUser(
  //   onSuccess: () async {
  //     log.v('==== SUCCESS User ====');

  //     if (_isOnBoardingSeen) {
  //       Platform.isIOS
  //           ? await _navService.replaceWithTransition(
  //               HomeView(),
  //               transition: NavigationTransition.Fade,
  //             )
  //           : await _navService.replaceWith(Routes.homeView);
  //     } else {
  //       Platform.isIOS
  //           ? await _navService.replaceWithTransition(
  //               OnBoardingView(),
  //               transition: NavigationTransition.Fade,
  //             )
  //           : await _navService.replaceWith(Routes.onBoardingView);
  //     }
  //   },
  //   onFail: () async {
  //     log.v('====== FAIL User ======');
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? _accessToken = prefs.getString(Constants.accessToken);
  //     if (_accessToken != null) {
  //       await prefs.remove(Constants.accessToken);
  //       _accessToken = prefs.getString(Constants.accessToken);
  //       log.i('ACCESS TOKEN after remove: $_accessToken');
  //     }
  //     await _userService.clearUser();

  //     if (_isOnBoardingSeen) {
  //       Platform.isIOS
  //           ? await _navService.replaceWithTransition(
  //               HomeView(),
  //               transition: NavigationTransition.Fade,
  //             )
  //           : await _navService.replaceWith(Routes.homeView);
  //     } else {
  //       Platform.isIOS
  //           ? await _navService.replaceWithTransition(
  //               OnBoardingView(),
  //               transition: NavigationTransition.Fade,
  //             )
  //           : await _navService.replaceWith(Routes.onBoardingView);
  //     }
  //   },
  // );

  @override
  Stream<ConnectivityStatus> get stream =>
      _connectivityService.connectionStatusController.stream;
}
