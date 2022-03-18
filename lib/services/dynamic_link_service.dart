import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import '../app/app.logger.dart';

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
}
