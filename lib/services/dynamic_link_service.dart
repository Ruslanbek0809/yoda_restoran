import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import '../app/app.logger.dart';
import '../models/models.dart';

class DynamicLinkService {
  final log = getLogger('DynamicLinkService');
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future handleDynamicLinks() async {
    log.v('====== DynamicLinkService STARTED ======');
    // 1. Get the initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData? data = await dynamicLinks.getInitialLink();

    // 2. handle link that has been retrieved
    if (data != null) _handleDeepLink(data);

    // 3. Register a link callback to fire if the app is opened up from the background
    // using a dynamic link.
    dynamicLinks.onLink.listen((PendingDynamicLinkData? dynamicLinkData) {
      log.v('====== DynamicLinkService Background / Foreground State ======');
      // 3a. handle link that has been retrieved
      if (dynamicLinkData != null) _handleDeepLink(dynamicLinkData);
    }).onError((error) {
      print('Link Failed: ${error.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData? data) {
    log.v('====== DynamicLinkService _handleDeepLink ======');
    final Uri? deepLink = data?.link;
    print('_handleDeepLink | deeplink: $deepLink');
  }

  Future<String> createDynamicLink(
    bool shortLink,
    ExclusiveSingle singleEx,
  ) async {
    /// CREATES parameters with all details
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      // The Dynamic Link URI domain. You can view created URIs on your Firebase console
      uriPrefix: 'https://yodarestoran.page.link/',
      // The deep Link passed to your application which you can use to affect change
      link: Uri.parse('https://yodarestoran.com/se?id=${singleEx.id}'),
      // Android application details needed for opening correct app on device/Play Store
      androidParameters: const AndroidParameters(
        packageName: 'tm.com.restoran.yoda',
        minimumVersion: 28,
      ),
      // iOS application details needed for opening correct app on device/App Store
      iosParameters: const IOSParameters(
        bundleId: 'com.restoran.yoda',
        minimumVersion: '2',
      ),
    );

    Uri uri;
    if (shortLink)
      uri = await dynamicLinks.buildLink(parameters);
    else {
      final ShortDynamicLink shortDynamicLink =
          await FirebaseDynamicLinks.instance.buildShortLink(parameters);
      uri = shortDynamicLink.shortUrl;
    }

    log.v('createDynamicLink() with uri => ${uri.toString()}');

    return uri.toString();
  }
}
