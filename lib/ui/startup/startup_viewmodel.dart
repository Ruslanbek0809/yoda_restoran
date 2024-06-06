import 'dart:io';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:yoda_res/generated/locale_keys.g.dart';
import 'package:yoda_res/services/sentry/sentry_module.dart';
import 'package:yoda_res/shared/shared.dart';

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

  Future<void> navToHomeWithConnection(
    Locale initLocale,
  ) async {
    log.i('===== navToHomeWithConnection() STARTED =====');

    // await flashController?.dismiss(); // DISMISSES no internet flashbar

    //*So this below condition is to change lang of API initialization to ru lang when app is opened for the first time. Drawback of easy_localization. Workaround
    if (initLocale.toString() == 'ru_RU') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final _savedLocale = prefs.getString(Constants.savedLocale) ??
          'en_US'; // GETS saved locale.

      if (_savedLocale != 'ru_RU')
        await prefs.setString(Constants.savedLocale, initLocale.toString());
    }

    //* Initialize Push Notification Service in a non-blocking way
    _pushNotificationService.initialise().catchError((error) {
      log.e('Error initializing PushNotificationService', error);
      reportExceptionToSentry(
        error,
        additionalInfo:
            'MY ERROR SENTRY => PushNotificationService initialisation',
      );
    });
    //* INITIALIZATION of FB Dynamic Link
    _dynamicLinkService.handleBFDynamicLinks().catchError((error) {
      log.e('Error initializing DynamicLinkService', error);
      reportExceptionToSentry(
        error,
        additionalInfo: 'MY ERROR SENTRY => DynamicLinkService initialization',
      );
    });

    //*DEPRECATED after app version 2.3.0+35
    // //*GETS user's location
    // await _geolocatorService.getUserLocation();

    await _apiRootService.initDio();
    await _hiveDbService.initHiveBoxes();
    _hiveDbService.getCartMeals(); //* GETS all CART meals insiede cartMealBox
    _hiveDbService.getCartRes(); //* GETS CART restaurant inside cartResBox
    _hiveDbService.getHiveRatings(); //* GETS hive ratings
    _hiveDbService.getHiveCreditCards(); //* GETS all hive credit cards
    await _hiveDbService.cleanStoriesBasedOnDeadlines();

    //* USE _userService.getInitialUser OR _userService.initUser
    await _userService.initUser();

    //* CHECKS whether onBoarding was SEEN or NOT
    var prefs = await SharedPreferences.getInstance();
    var _isOnBoardingSeen = prefs.getBool(Constants.isOnBoardingSeen) ?? false;
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
  }

  @override
  Stream<ConnectivityStatus> get stream =>
      _connectivityService.connectionStatusController.stream;
}
