import 'dart:io';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app.locator.dart';
import 'models/hive_models/hive_models.dart';
import 'ui/setup_bottom_sheet.dart';
import 'ui/setup_dialog.dart';
import 'ui/setup_snackbar.dart';
import 'utils/utils.dart';
import 'yoda_res_app.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter<HiveUser>(HiveUserAdapter());
  Hive.registerAdapter<HiveRestaurant>(HiveRestaurantAdapter());
  Hive.registerAdapter<HiveResPaymentType>(HiveResPaymentTypeAdapter());
  Hive.registerAdapter<HiveMeal>(HiveMealAdapter());
  Hive.registerAdapter<HiveVolCus>(HiveVolCusAdapter());
  Hive.registerAdapter<HiveRating>(HiveRatingAdapter());
  Hive.registerAdapter<HiveCreditCard>(HiveCreditCardAdapter());
  setupLocator();
  setupBottomSheet();
  setupDialog();
  setupSnackbar();

  // When the app is completely closed (not in the background) and opened directly from the push notification
  FirebaseMessaging.onBackgroundMessage(fbBackgroundHandler); //* FB Background

  runApp(
    EasyLocalization(
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
  );
}
