import 'dart:io';

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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Got a message whilst in the onBackgroundMessage!');
  print('Message data: ${message.data}');

  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification}');
    print(
        'Message also contained a notification\' title: ${message.notification!.title}');
    print(
        'Message also contained a notification\' body: ${message.notification!.body}');
  }
  print('Handling a background message ${message.messageId}');
}

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
  setupLocator();
  setupBottomSheet();
  setupDialog();
  setupSnackbar();

  // When the app is completely closed (not in the background) and opened directly from the push notification
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: [Locale('en', 'US'), Locale('ru', 'RU')],
      fallbackLocale: Locale('en', 'US'),
      child: YodaResApp(),
    ),
  );
}
