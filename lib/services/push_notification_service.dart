import 'package:firebase_messaging/firebase_messaging.dart';
import '../app/app.logger.dart';
import '../utils/utils.dart';

class PushNotificationService {
  final log = getLogger('PushNotificationService');

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  Future initialise() async {
    log.v('====== PushNotificationService STARTED Fcm Token ======');

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
    log.v('FCM permission: ${settings.authorizationStatus}');

    /// Here we get fcmToken and store it in _fcmToken
    _fcmToken = await _fcm.getToken();
    log.v('FCM Token: $_fcmToken');

    /// Here we subcscribe to topic so that we send specific message to specific devices
    _fcm.subscribeToTopic(Constants.topicAllDevices);

    /// When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log.v('Got a message whilst in the foreground onMessage!');
      log.v('Message data: ${message.data}');

      if (message.notification != null) {
        log.v('Message also contained a notification: ${message.notification}');
      }
    });

    /// When the app is in the background and opened directly from the push notification. and to open a notification message displayed via FCM
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log.v('Got a message whilst in the foreground onMessageOpenedApp!');
      log.v('Message data: ${message.data}');

      if (message.notification != null) {
        log.v('Message also contained a notification: ${message.notification}');
      }
    });

    log.v('====== PushNotificationService ENDED Fcm Token ======');
  }
}
