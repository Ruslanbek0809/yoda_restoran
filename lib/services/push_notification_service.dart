import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:yoda_res/app/app.logger.dart';
import 'package:yoda_res/utils/utils.dart';

class PushNotificationService {
  final log = getLogger('PushNotificationService');

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  Future initialise() async {
    /// This function is used to authorize permissions. On Anroid not needed. Here I use it to see authorizationStatus
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    log.i('FCM permission: ${settings.authorizationStatus}');

    /// Here we get fcmToken and store it in _fcmToken
    _fcmToken = await _fcm.getToken();
    log.i('FCM Token: $_fcmToken');

    /// Here we subcscribe to topic so that we send specific message to specific devices
    _fcm.subscribeToTopic(Constants.topicAllDevices);

    /// When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground onMessage!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    /// When the app is completely closed (not in the background) and opened directly from the push notification and to open a notification message displayed via FCM
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground onMessageOpenedApp!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }
}
