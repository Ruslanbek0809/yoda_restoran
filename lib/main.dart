import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:yoda_res/services/sentry/sentry_module.dart';
import 'app/app.locator.dart';
import 'models/hive_models/hive_models.dart';
import 'models/hive_models/hive_story.dart';
import 'ui/setup_bottom_sheet.dart';
import 'ui/setup_dialog.dart';
import 'ui/setup_snackbar.dart';
import 'utils/utils.dart';
import 'yoda_res_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //* Set up global HTTP overrides
  HttpOverrides.global = MyHttpOverrides();

  try {
    await EasyLocalization.ensureInitialized();
  } catch (e, stackTrace) {
    reportExceptionToSentryWithStacktrace(
      e,
      additionalInfo:
          'MY ERROR SENTRY => EasyLocalization initialization error',
      stackTrace: stackTrace,
    );
  }
  try {
    await Firebase.initializeApp();
  } catch (e, stackTrace) {
    reportExceptionToSentryWithStacktrace(
      e,
      additionalInfo: 'MY ERROR SENTRY => Firebase initialization error',
      stackTrace: stackTrace,
    );
  }

  try {
    await Hive.initFlutter();
  } catch (e, stackTrace) {
    reportExceptionToSentryWithStacktrace(
      e,
      additionalInfo: 'MY ERROR SENTRY => Hive initialization error',
      stackTrace: stackTrace,
    );
  }

  //* Register Hive adapters
  try {
    Hive.registerAdapter<HiveUser>(HiveUserAdapter());
    Hive.registerAdapter<HiveRestaurant>(HiveRestaurantAdapter());
    Hive.registerAdapter<HiveResPaymentType>(HiveResPaymentTypeAdapter());
    Hive.registerAdapter<HiveMeal>(HiveMealAdapter());
    Hive.registerAdapter<HiveVolCus>(HiveVolCusAdapter());
    Hive.registerAdapter<HiveRating>(HiveRatingAdapter());
    Hive.registerAdapter<HiveCreditCard>(HiveCreditCardAdapter());
    Hive.registerAdapter<HiveStory>(HiveStoryAdapter());
  } catch (e, stackTrace) {
    reportExceptionToSentryWithStacktrace(
      e,
      additionalInfo: 'MY ERROR SENTRY => Hive adapter registration error',
      stackTrace: stackTrace,
    );
  }

  //* Initialize services
  try {
    setupLocator();
    setupBottomSheet();
    setupDialog();
    setupSnackbar();
  } catch (e, stackTrace) {
    reportExceptionToSentryWithStacktrace(
      e,
      additionalInfo: 'MY ERROR SENTRY => Service setup error',
      stackTrace: stackTrace,
    );
  }

  //! ---------- SENTRY CONFIG -------- //
  //* Initialize Sentry
  try {
    await initializeSentry();
  } catch (e, stackTrace) {
    reportExceptionToSentryWithStacktrace(
      e,
      additionalInfo: 'MY ERROR SENTRY => Sentry initialization error',
      stackTrace: stackTrace,
    );
  }

  //* When the app is completely closed (not in the background) and opened directly from the push notification
  FirebaseMessaging.onBackgroundMessage(fbBackgroundHandler); //* FB Background

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    //* Capture the error in Sentry. This handler is specific to Flutter framework errors.
    //* It catches exceptions thrown during the Flutter build, layout, and paint phases.
    //* These are typically errors related to the Flutter widget tree
    reportExceptionToSentryWithStacktrace(
      details.exception,
      additionalInfo: 'MY ERROR SENTRY => Flutter framework error',
      stackTrace: details.stack,
    );
  };

  //* Run the app within a guarded zone to capture any uncaught errors
  await runZonedGuarded<Future<void>>(
    () async {
      runApp(
        //* Sentry's performance tracing for AssetBundles.
        DefaultAssetBundle(
          bundle: SentryAssetBundle(),
          child: EasyLocalization(
            path: 'assets/translations',
            supportedLocales: const [Locale('en', 'US'), Locale('ru', 'RU')],
            fallbackLocale: const Locale('en', 'US'),
            child:
                // DevicePreview(
                //   enabled: !kReleaseMode,
                //   builder: (context) =>
                YodaResApp(), //* Config DevicePreview
            // ),
          ),
        ),
      );
    },
    (exception, stackTrace) {
      //* This is a broader error handler that captures uncaught errors in the Dart zone.
      //* It includes errors from asynchronous operations (like Futures and Streams), I/O operations,
      //* and other Dart code that is not part of the Flutter framework.
      reportExceptionToSentryWithStacktrace(
        exception,
        additionalInfo: 'MY ERROR SENTRY => Uncaught async error',
        stackTrace: stackTrace,
      );
    },
  );
}
