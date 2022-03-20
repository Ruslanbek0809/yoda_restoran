import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:stacked_services/stacked_services.dart';

import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../app/app.router.dart';
import '../models/models.dart';

class DynamicLinkService {
  final log = getLogger('DynamicLinkService');
  final _navService = locator<NavigationService>();

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  /// HANDLES Foreground/Background dynamic link
  Future handleBFDynamicLinks() async {
    log.v('====== DynamicLinkService handleBFDynamicLinks() STARTED ======');

    // /// #1 GETS the initial dynamic link if the app is opened with a dynamic link
    // final PendingDynamicLinkData? data = await dynamicLinks.getInitialLink();

    // /// HANDLES clicked dynamic link
    // if (data != null) _handleDeepLink(data);

    /// #2 GETS dynamic link in Background / Foreground State
    dynamicLinks.onLink.listen((PendingDynamicLinkData? dynamicLinkData) {
      log.v('====== DynamicLinkService Background / Foreground State ======');
      // 3a. handle link that has been retrieved
      if (dynamicLinkData != null) _handleDeepLink(dynamicLinkData);
    }).onError((error) {
      print('Link Failed: ${error.message}');
    });
  }

  /// HANDLES clicked terminated dynamic link
  Future handleClickedDynamicLinks() async {
    log.v('====== DynamicLinkService handleClickDynamicLinks() STARTED ======');

    /// #1 GETS the initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData? data = await dynamicLinks.getInitialLink();

    /// HANDLES clicked dynamic link
    if (data != null) _handleDeepLink(data);
  }

  void _handleDeepLink(PendingDynamicLinkData? data) {
    log.v('====== DynamicLinkService _handleDeepLink ======');
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      print('_handleDeepLink | deeplink: $deepLink');

      // Check if deep link path CONTAINS word 'se'
      var isSingleEx = deepLink.pathSegments.contains('se');

      if (isSingleEx) {
        print('deepLink.queryParameters: ${deepLink.queryParameters}');

        // get data of single exclusive from deepLink.queryParameters
        var singleExId = deepLink.queryParameters['id'];
        var singleExOrder = deepLink.queryParameters['order'];
        var singleExName = deepLink.queryParameters['name'];
        var singleExImage = deepLink.queryParameters['image'];
        var singleExOption = deepLink.queryParameters['option'];
        var singleExUrl = deepLink.queryParameters['url'];

        if (singleExId != null) {
          //------------------ NAVIGATION to SingleExclusive ---------------------//
          _navService.navigateTo(
            Routes.exclusiveSingleView,
            arguments: ExclusiveSingleViewArguments(
                exclusiveSingle: ExclusiveSingle(
              id: int.parse(singleExId),
              order: int.parse(singleExOrder!),
              name: singleExName,
              image: singleExImage,
              option: singleExOption,
              url: singleExUrl,
            )),
          );
        }
      }
    }
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
      link: Uri.parse(
          'https://yodarestoran.com/se?id=${singleEx.id}&order=${singleEx.order}&name=${singleEx.name}&image=${singleEx.image}&option=${singleEx.option}&url=${singleEx.url}'),
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
    if (shortLink) {
      final ShortDynamicLink shortDynamicLink =
          await FirebaseDynamicLinks.instance.buildShortLink(parameters);
      uri = shortDynamicLink.shortUrl;
    } else {
      uri = await dynamicLinks.buildLink(parameters);
    }

    log.v('createDynamicLink() with uri => ${uri.toString()}');

    return uri.toString();
  }
}
