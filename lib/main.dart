import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.locator.dart';
import 'models/hive_models/hive_models.dart';
import 'ui/setup_bottom_sheet.dart';
import 'ui/setup_dialog.dart';
import 'yoda_res_app.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter<HiveRestaurant>(HiveRestaurantAdapter());
  Hive.registerAdapter<HiveMeal>(HiveMealAdapter());
  Hive.registerAdapter<HiveVolCus>(HiveVolCusAdapter());
  Hive.registerAdapter<HiveUser>(HiveUserAdapter());
  setupLocator();
  setupBottomSheet();
  setupDialog();

  // When the app is completely closed (not in the background) and opened directly from the push notification
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(YodaResApp());
}
