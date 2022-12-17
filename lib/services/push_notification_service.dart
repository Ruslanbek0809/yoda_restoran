import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stacked_services/stacked_services.dart' hide Trans;
import '../app/app.locator.dart';
import '../generated/locale_keys.g.dart';
import '../models/models.dart';
import '../app/app.logger.dart';
import '../utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';

class PushNotificationService {
  final log = getLogger('PushNotificationService');

  final _dialogService = locator<DialogService>();

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
    _fcm.subscribeToTopic(Constants.topicAndroidDevices);
    _fcm.subscribeToTopic(Constants.topicIosDevices);

    /// When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log.v('Got a message whilst in the foreground onMessage!');
      log.v('Message data: ${message.data}');

      if (message.notification != null) {
        log.v('Message also contained a notification: ${message.notification}');
        log.v(
            'Message also contained a notification\' title: ${message.notification!.title}');
        log.v(
            'Message also contained a notification\' body: ${message.notification!.body}');
      }

      final noti = NotificationModel.fromJson(message.data);
      log.v(
          'notificationData JSON title: ${noti.title}, status: ${noti.status}');

      switch (noti.status) {
        case '2':
          log.v('INSIDE STATUS 2');
          await _dialogService.showCustomDialog(
            variant: DialogType.notification,
            showIconInMainButton: false,
            barrierDismissible: true,
            data: NotificationDialogData(
              lottie: 'assets/success_check.json',
              restaurant: noti.title!,
              content: LocaleKeys.yourOrderAccepted.tr(),
            ),
          );
          break;
        case '3':
          log.v('INSIDE STATUS 3');
          if (noti.selfPickUp == 'True')
            await _dialogService.showCustomDialog(
              variant: DialogType.notification,
              showIconInMainButton: false,
              barrierDismissible: true,
              data: NotificationDialogData(
                lottie: 'assets/pizzabox.json',
                restaurant: noti.title!,
                content: LocaleKeys.yourOrderReady.tr(),
              ),
            );
          if (noti.selfPickUp != null && noti.selfPickUp == 'False')
            await _dialogService.showCustomDialog(
              variant: DialogType.notification,
              showIconInMainButton: false,
              barrierDismissible: true,
              data: NotificationDialogData(
                lottie: 'assets/foodbag.json',
                restaurant: noti.title!,
                content: LocaleKeys.yourOrderSent.tr(),
              ),
            );
          break;
        case '4':
          log.v('INSIDE STATUS 4');
          await _dialogService.showCustomDialog(
            variant: DialogType.rateOrder,
            showIconInMainButton: false,
            barrierDismissible: true,
            data: noti,
          );
          break;
        default:
      }
    });

    /// When the app is in the background and opened directly from the push notification. and to open a notification message displayed via FCM
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      log.v('Got a message whilst in the foreground onMessageOpenedApp!');
      log.v('Message data: ${message.data}');

      if (message.notification != null) {
        log.v('Message also contained a notification: ${message.notification}');
        log.v(
            'Message also contained a notification\' title: ${message.notification!.title}');
        log.v(
            'Message also contained a notification\' body: ${message.notification!.body}');
      }
      final noti = NotificationModel.fromJson(message.data);
      log.v(
          'notificationData JSON title: ${noti.title}, status: ${noti.status}');

      /// NO need to reload when notification status is 4. Else, RELOAD
      if (noti.status == '4') {
        log.v('INSIDE STATUS 4');
        await _dialogService.showCustomDialog(
          variant: DialogType.rateOrder,
          showIconInMainButton: false,
          barrierDismissible: true,
          data: noti,
        );
      }
    });

    log.v('====== PushNotificationService ENDED Fcm Token ======');
  }
}
